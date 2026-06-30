import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';

/// OIDs relevantes para parsing de PKCS#12
const _oidData = '1.2.840.113549.1.7.1';
const _oidEncryptedData = '1.2.840.113549.1.7.6';
const _oidPkcs8ShroudedKeyBag = '1.2.840.113549.1.12.10.1.2';
const _oidCertBag = '1.2.840.113549.1.12.10.1.3';
const _oidX509Certificate = '1.2.840.113549.1.9.22.1';
const _oidPbeWithShaAnd3KeyTripleDes = '1.2.840.113549.1.12.1.3';
const _oidPbeWithShaAnd40BitRc2 = '1.2.840.113549.1.12.1.6';

/// Resultado do parsing PKCS#12.
///
/// - [privateKey] — chave privada RSA (para assinatura XML com pointycastle).
/// - [certDer]   — certificado X.509 em DER (para embutir na assinatura XML).
/// - [pkcs8Der]  — chave privada decriptografada em PKCS#8 DER (para mTLS via SecurityContext).
typedef Pkcs12Result = ({
  RSAPrivateKey privateKey,
  Uint8List certDer,
  Uint8List pkcs8Der,
});

/// Extrai a chave privada RSA e o certificado DER de um arquivo PFX/P12 (certificado A1).
class Pkcs12Reader {
  static Pkcs12Result parse(Uint8List pfxBytes, String password) {
    // Senha no formato PKCS#12 BMPString: UTF-16BE + terminador nulo
    final pwBytes = _encodeBmpString(password);

    // Outer PFX: SEQUENCE { version INTEGER, authSafe ContentInfo, macData OPTIONAL }
    final pfx = ASN1Parser(pfxBytes).nextObject() as ASN1Sequence;
    final authSafeCI = pfx.elements[1] as ASN1Sequence;
    final authSafeOid =
        (authSafeCI.elements[0] as ASN1ObjectIdentifier).identifier!;

    if (authSafeOid != _oidData) {
      throw UnsupportedError('Tipo de authSafe não suportado: $authSafeOid');
    }

    // [0] EXPLICIT OCTET STRING contendo a AuthenticatedSafe DER
    final cont = authSafeCI.elements[1];
    final octet = ASN1Parser(cont.valueBytes()).nextObject() as ASN1OctetString;
    final authSafeBytes = octet.octets;

    // AuthenticatedSafe ::= SEQUENCE OF ContentInfo
    final authSafe = ASN1Parser(authSafeBytes).nextObject() as ASN1Sequence;

    RSAPrivateKey? privateKey;
    Uint8List? certDer;
    Uint8List? pkcs8Der;

    for (final ci in authSafe.elements) {
      final contentInfo = ci as ASN1Sequence;
      final oid =
          (contentInfo.elements[0] as ASN1ObjectIdentifier).identifier!;

      final Uint8List safeContentsBytes;

      if (oid == _oidData) {
        // Plaintext SafeContents
        final inner = contentInfo.elements[1];
        final os = ASN1Parser(inner.valueBytes()).nextObject() as ASN1OctetString;
        safeContentsBytes = os.octets;
      } else if (oid == _oidEncryptedData) {
        // EncryptedData — descriptografar com a senha
        final inner = contentInfo.elements[1];
        final encData = ASN1Parser(inner.valueBytes()).nextObject() as ASN1Sequence;
        // EncryptedData: { version, encryptedContentInfo }
        final eci = encData.elements[1] as ASN1Sequence;
        safeContentsBytes = _decryptEci(eci, pwBytes);
      } else {
        continue;
      }

      // SafeContents ::= SEQUENCE OF SafeBag
      final safeBags =
          ASN1Parser(safeContentsBytes).nextObject() as ASN1Sequence;

      for (final bag in safeBags.elements) {
        final safeBag = bag as ASN1Sequence;
        final bagId = (safeBag.elements[0] as ASN1ObjectIdentifier).identifier!;
        final bagValue = safeBag.elements[1];

        if (bagId == _oidPkcs8ShroudedKeyBag) {
          final shroudedKey =
              ASN1Parser(bagValue.valueBytes()).nextObject() as ASN1Sequence;
          final (key: pk, pkcs8: p8) = _decryptShroudedKeyFull(shroudedKey, pwBytes);
          privateKey = pk;
          pkcs8Der = p8;
        } else if (bagId == _oidCertBag) {
          final certBagSeq =
              ASN1Parser(bagValue.valueBytes()).nextObject() as ASN1Sequence;
          final certType =
              (certBagSeq.elements[0] as ASN1ObjectIdentifier).identifier!;
          if (certType == _oidX509Certificate) {
            final certCont = certBagSeq.elements[1];
            final certOs =
                ASN1Parser(certCont.valueBytes()).nextObject() as ASN1OctetString;
            certDer = certOs.octets;
          }
        }
      }
    }

    if (privateKey == null || pkcs8Der == null) {
      throw StateError('Chave privada não encontrada no PFX');
    }
    if (certDer == null) {
      throw StateError('Certificado não encontrado no PFX');
    }

    return (privateKey: privateKey, certDer: certDer, pkcs8Der: pkcs8Der);
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// Converte a senha para BMPString (UTF-16BE + terminador nulo), como exige o PKCS#12.
  static Uint8List _encodeBmpString(String s) {
    final bytes = Uint8List((s.length + 1) * 2);
    for (var i = 0; i < s.length; i++) {
      final c = s.codeUnitAt(i);
      bytes[i * 2] = (c >> 8) & 0xFF;
      bytes[i * 2 + 1] = c & 0xFF;
    }
    return bytes;
  }

  /// Descriptografa um EncryptedContentInfo usando a senha.
  static Uint8List _decryptEci(ASN1Sequence eci, Uint8List password) {
    // EncryptedContentInfo: { contentType, contentEncryptionAlgorithm, [0] encryptedContent }
    final algId = eci.elements[1] as ASN1Sequence;
    final algOid = (algId.elements[0] as ASN1ObjectIdentifier).identifier!;
    final encContentObj = eci.elements[2];

    Uint8List ciphertext;
    try {
      ciphertext =
          (ASN1Parser(encContentObj.valueBytes()).nextObject() as ASN1OctetString)
              .octets;
    } catch (_) {
      ciphertext = encContentObj.valueBytes();
    }

    final params = algId.elements[1] as ASN1Sequence;
    return _pbeDecrypt(algOid, params, ciphertext, password);
  }

  /// Descriptografa um PKCS8ShroudedKeyBag e retorna a RSAPrivateKey + bytes PKCS#8 DER.
  static ({RSAPrivateKey key, Uint8List pkcs8}) _decryptShroudedKeyFull(
      ASN1Sequence shroudedKey, Uint8List password) {
    final algId = shroudedKey.elements[0] as ASN1Sequence;
    final algOid = (algId.elements[0] as ASN1ObjectIdentifier).identifier!;
    final encKey = (shroudedKey.elements[1] as ASN1OctetString).octets;
    final params = algId.elements[1] as ASN1Sequence;
    final pkcs8Bytes = _pbeDecrypt(algOid, params, encKey, password);
    return (key: _parseRsaPrivateKey(pkcs8Bytes), pkcs8: pkcs8Bytes);
  }

  /// Despacha para o algoritmo PBE correto.
  static Uint8List _pbeDecrypt(
      String algOid, ASN1Sequence params, Uint8List data, Uint8List password) {
    switch (algOid) {
      case _oidPbeWithShaAnd3KeyTripleDes:
        return _pkcs12PbeDec(params, data, password, 24, 8, false);
      case _oidPbeWithShaAnd40BitRc2:
        return _pkcs12PbeDec(params, data, password, 5, 8, true);
      default:
        throw UnsupportedError('Algoritmo PBE não suportado: $algOid');
    }
  }

  /// PKCS#12 PBE com SHA-1, derivando chave+IV e descriptografando com 3DES ou RC2.
  static Uint8List _pkcs12PbeDec(ASN1Sequence params, Uint8List data,
      Uint8List password, int keyLen, int ivLen, bool useRc2) {
    final salt = (params.elements[0] as ASN1OctetString).octets;
    final iterations =
        (params.elements[1] as ASN1Integer).valueAsBigInteger.toInt();

    final key = _pkcs12Kdf(password, salt, iterations, 1, keyLen);
    final iv = _pkcs12Kdf(password, salt, iterations, 2, ivLen);

    if (useRc2) {
      return _decryptRc2Cbc(key, iv, data, 40);
    } else {
      return _decrypt3DesCbc(key, iv, data);
    }
  }

  /// PKCS#12 Appendix B Key Derivation (SHA-1 based).
  static Uint8List _pkcs12Kdf(
      Uint8List password, Uint8List salt, int iterations, int id, int keyLen) {
    const v = 64; // SHA-1 block size
    const u = 20; // SHA-1 digest size

    final diversifier = Uint8List(v)..fillRange(0, v, id);

    // S = salt padded to multiple of v
    final sLen = salt.isEmpty ? 0 : v * ((salt.length + v - 1) ~/ v);
    // P = password padded to multiple of v
    final pLen = password.isEmpty ? 0 : v * ((password.length + v - 1) ~/ v);

    final intermediate = Uint8List(sLen + pLen);
    for (var i = 0; i < sLen; i++) {
      intermediate[i] = salt[i % salt.length];
    }
    for (var i = 0; i < pLen; i++) {
      intermediate[sLen + i] = password[i % password.length];
    }

    final c = (keyLen + u - 1) ~/ u;
    final result = Uint8List(c * u);
    final sha1 = SHA1Digest();
    final ai = Uint8List(u);

    for (var idx = 0; idx < c; idx++) {
      sha1
        ..reset()
        ..update(diversifier, 0, diversifier.length)
        ..update(intermediate, 0, intermediate.length)
        ..doFinal(ai, 0);

      for (var j = 1; j < iterations; j++) {
        sha1
          ..reset()
          ..update(ai, 0, u)
          ..doFinal(ai, 0);
      }

      result.setRange(idx * u, (idx + 1) * u, ai);

      // I_j = (I_j + A_i + 1) mod 2^v, para cada bloco de v bytes
      final blocks = intermediate.length ~/ v;
      for (var j = 0; j < blocks; j++) {
        var carry = 1;
        for (var k = v - 1; k >= 0; k--) {
          final sum =
              (intermediate[j * v + k] & 0xFF) + (ai[k % u] & 0xFF) + carry;
          intermediate[j * v + k] = sum & 0xFF;
          carry = sum >> 8;
        }
      }
    }

    return result.sublist(0, keyLen);
  }

  /// Descriptografa com 3DES-CBC e remove padding PKCS7.
  static Uint8List _decrypt3DesCbc(
      Uint8List key, Uint8List iv, Uint8List data) {
    final cipher = CBCBlockCipher(DESedeEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), iv));

    final out = Uint8List(data.length);
    for (var i = 0; i < data.length; i += cipher.blockSize) {
      cipher.processBlock(data, i, out, i);
    }
    return _removePkcs7Padding(out);
  }

  /// Descriptografa com RC2-CBC e remove padding PKCS7.
  static Uint8List _decryptRc2Cbc(
      Uint8List key, Uint8List iv, Uint8List data, int effectiveBits) {
    final rc2 = _Rc2Engine()..init(false, key, effectiveBits);
    const blockSize = 8;
    final out = Uint8List(data.length);
    var prevBlock = iv;

    for (var i = 0; i < data.length; i += blockSize) {
      final decrypted = rc2.processBlock(data.sublist(i, i + blockSize));
      for (var j = 0; j < blockSize; j++) {
        out[i + j] = decrypted[j] ^ prevBlock[j];
      }
      prevBlock = data.sublist(i, i + blockSize);
    }
    return _removePkcs7Padding(out);
  }

  /// Remove padding PKCS7 do bloco descriptografado.
  static Uint8List _removePkcs7Padding(Uint8List data) {
    final padLen = data.last;
    if (padLen < 1 || padLen > 16) {
      throw StateError('Padding PKCS7 inválido: $padLen');
    }
    return data.sublist(0, data.length - padLen);
  }

  /// Parseia uma RSAPrivateKey de bytes PKCS#8 DER.
  static RSAPrivateKey _parseRsaPrivateKey(Uint8List pkcs8Der) {
    // PrivateKeyInfo ::= SEQUENCE { version, algorithm, privateKey OCTET STRING }
    final pki = ASN1Parser(pkcs8Der).nextObject() as ASN1Sequence;
    final privateKeyOctet = pki.elements[2] as ASN1OctetString;

    // RSAPrivateKey ::= SEQUENCE { version, n, e, d, p, q, dp, dq, qInv }
    final rsa =
        ASN1Parser(privateKeyOctet.octets).nextObject() as ASN1Sequence;
    final els = rsa.elements;

    BigInt bigAt(int i) => (els[i] as ASN1Integer).valueAsBigInteger;

    return RSAPrivateKey(bigAt(1), bigAt(3), bigAt(4), bigAt(5));
  }
}

// ─── RC2 cipher (RFC 2268) ───────────────────────────────────────────────────

class _Rc2Engine {
  static const _piTable = <int>[
    0xD9, 0x78, 0xF9, 0xC4, 0x19, 0xDD, 0xB5, 0xED, 0x28, 0xE9, 0xFD, 0x79,
    0x4A, 0xA0, 0xD8, 0x9D, 0xC6, 0x7E, 0x37, 0x83, 0x2B, 0x76, 0x53, 0x8E,
    0x62, 0x4C, 0x64, 0x88, 0x44, 0x8B, 0xFB, 0xA2, 0x17, 0x9A, 0x59, 0xF5,
    0x87, 0xB3, 0x4F, 0x13, 0x61, 0x45, 0x6D, 0x8D, 0x09, 0x81, 0x7D, 0x32,
    0xBD, 0x8F, 0x40, 0xEB, 0x86, 0xB7, 0x7B, 0x0B, 0xF0, 0x95, 0x21, 0x22,
    0x5C, 0x6B, 0x4E, 0x82, 0x54, 0xD6, 0x65, 0x93, 0xCE, 0x60, 0xB2, 0x1C,
    0x73, 0x56, 0xC0, 0x14, 0xA7, 0x8C, 0xF1, 0xDC, 0x12, 0x75, 0xCA, 0x1F,
    0x3B, 0xBE, 0xE4, 0xD1, 0x42, 0x3D, 0xD4, 0x30, 0xA3, 0x3C, 0xB6, 0x26,
    0x6F, 0xBF, 0x0E, 0xDA, 0x46, 0x69, 0x07, 0x57, 0x27, 0xF2, 0x1D, 0x9B,
    0xBC, 0x94, 0x43, 0x03, 0xF8, 0x11, 0xC7, 0xF6, 0x90, 0xEF, 0x3E, 0xE7,
    0x06, 0xC3, 0xD5, 0x2F, 0xC8, 0x66, 0x1E, 0xD7, 0x08, 0xE8, 0xEA, 0xDE,
    0x80, 0x52, 0xEE, 0xF7, 0x84, 0xAA, 0x72, 0xAC, 0x35, 0x4D, 0x6A, 0x2A,
    0x96, 0x1A, 0xD2, 0x71, 0x5A, 0x15, 0x49, 0x74, 0x4B, 0x9F, 0xD0, 0x5E,
    0x04, 0x18, 0xA4, 0xEC, 0xC2, 0xE0, 0x41, 0x6E, 0x0F, 0x51, 0xCB, 0xCC,
    0x24, 0x91, 0xAF, 0x50, 0xA1, 0xF4, 0x70, 0x39, 0x99, 0x7C, 0x3A, 0x85,
    0x23, 0xB8, 0xB4, 0x7A, 0xFC, 0x02, 0x36, 0x5B, 0x25, 0x55, 0x97, 0x31,
    0x2D, 0x5D, 0xFA, 0x98, 0xE3, 0x8A, 0x92, 0xAE, 0x05, 0xDF, 0x29, 0x10,
    0x67, 0x6C, 0xBA, 0xC9, 0xD3, 0x00, 0xE6, 0xCF, 0xE1, 0x9E, 0xA8, 0x2C,
    0x63, 0x16, 0x01, 0x3F, 0x58, 0xE2, 0x89, 0xA9, 0x0D, 0x38, 0x34, 0x1B,
    0xAB, 0x33, 0xFF, 0xB0, 0xBB, 0x48, 0x0C, 0x5F, 0xB9, 0xB1, 0xCD, 0x2E,
    0xC5, 0xF3, 0xDB, 0x47, 0xE5, 0xA5, 0x9C, 0x77, 0x0A, 0xA6, 0x20, 0x68,
    0xFE, 0x7F, 0xC1, 0xAD,
  ];

  // Expanded key: 64 words de 16 bits
  final _expandedKey = List<int>.filled(64, 0);
  late bool _forEncryption;

  void init(bool forEncryption, Uint8List key, int effectiveBits) {
    _forEncryption = forEncryption;

    // Key expansion (RFC 2268 §2)
    final keyBytes = List<int>.filled(128, 0);
    for (var i = 0; i < key.length; i++) {
      keyBytes[i] = key[i];
    }
    for (var i = key.length; i < 128; i++) {
      keyBytes[i] = _piTable[(keyBytes[i - 1] + keyBytes[i - key.length]) & 0xFF];
    }

    final t8 = (effectiveBits + 7) ~/ 8;
    final tm = 0xFF >> (8 * t8 - effectiveBits);
    keyBytes[128 - t8] = _piTable[keyBytes[128 - t8] & tm];
    for (var i = 127 - t8; i >= 0; i--) {
      keyBytes[i] = _piTable[keyBytes[i + 1] ^ keyBytes[i + t8]];
    }

    for (var i = 0; i < 64; i++) {
      _expandedKey[i] = (keyBytes[2 * i] & 0xFF) | ((keyBytes[2 * i + 1] & 0xFF) << 8);
    }
  }

  Uint8List processBlock(Uint8List block) {
    return _forEncryption ? _encrypt(block) : _decrypt(block);
  }

  Uint8List _encrypt(Uint8List block) {
    var r0 = (block[0] & 0xFF) | ((block[1] & 0xFF) << 8);
    var r1 = (block[2] & 0xFF) | ((block[3] & 0xFF) << 8);
    var r2 = (block[4] & 0xFF) | ((block[5] & 0xFF) << 8);
    var r3 = (block[6] & 0xFF) | ((block[7] & 0xFF) << 8);
    final k = _expandedKey;

    var j = 0;
    for (var i = 0; i < 16; i++) {
      r0 = _rotL((r0 + k[j++] + (r3 & r2) + (~r3 & r1)) & 0xFFFF, 1);
      r1 = _rotL((r1 + k[j++] + (r0 & r3) + (~r0 & r2)) & 0xFFFF, 2);
      r2 = _rotL((r2 + k[j++] + (r1 & r0) + (~r1 & r3)) & 0xFFFF, 3);
      r3 = _rotL((r3 + k[j++] + (r2 & r1) + (~r2 & r0)) & 0xFFFF, 5);
      if (i == 4 || i == 11) {
        r0 = (r0 + k[r3 & 63]) & 0xFFFF;
        r1 = (r1 + k[r0 & 63]) & 0xFFFF;
        r2 = (r2 + k[r1 & 63]) & 0xFFFF;
        r3 = (r3 + k[r2 & 63]) & 0xFFFF;
      }
    }

    return Uint8List.fromList([
      r0 & 0xFF, (r0 >> 8) & 0xFF,
      r1 & 0xFF, (r1 >> 8) & 0xFF,
      r2 & 0xFF, (r2 >> 8) & 0xFF,
      r3 & 0xFF, (r3 >> 8) & 0xFF,
    ]);
  }

  Uint8List _decrypt(Uint8List block) {
    var r0 = (block[0] & 0xFF) | ((block[1] & 0xFF) << 8);
    var r1 = (block[2] & 0xFF) | ((block[3] & 0xFF) << 8);
    var r2 = (block[4] & 0xFF) | ((block[5] & 0xFF) << 8);
    var r3 = (block[6] & 0xFF) | ((block[7] & 0xFF) << 8);
    final k = _expandedKey;

    for (var i = 15; i >= 0; i--) {
      if (i == 4 || i == 11) {
        r3 = (r3 - k[r2 & 63]) & 0xFFFF;
        r2 = (r2 - k[r1 & 63]) & 0xFFFF;
        r1 = (r1 - k[r0 & 63]) & 0xFFFF;
        r0 = (r0 - k[r3 & 63]) & 0xFFFF;
      }
      final j = 4 * i;
      r3 = _rotR(r3, 5);
      r3 = (r3 - k[j + 3] - (r2 & r1) - (~r2 & r0)) & 0xFFFF;
      r2 = _rotR(r2, 3);
      r2 = (r2 - k[j + 2] - (r1 & r0) - (~r1 & r3)) & 0xFFFF;
      r1 = _rotR(r1, 2);
      r1 = (r1 - k[j + 1] - (r0 & r3) - (~r0 & r2)) & 0xFFFF;
      r0 = _rotR(r0, 1);
      r0 = (r0 - k[j] - (r3 & r2) - (~r3 & r1)) & 0xFFFF;
    }

    return Uint8List.fromList([
      r0 & 0xFF, (r0 >> 8) & 0xFF,
      r1 & 0xFF, (r1 >> 8) & 0xFF,
      r2 & 0xFF, (r2 >> 8) & 0xFF,
      r3 & 0xFF, (r3 >> 8) & 0xFF,
    ]);
  }

  static int _rotL(int v, int n) => ((v << n) | (v >> (16 - n))) & 0xFFFF;
  static int _rotR(int v, int n) => ((v >> n) | (v << (16 - n))) & 0xFFFF;
}
