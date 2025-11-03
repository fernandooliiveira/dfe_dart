import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';

class CertBundle {
  CertBundle({
    required this.privateKey,
    required this.certData,
    required this.certB64,
    required this.pemPrivateKey,
    required this.pemChain,
  });

  final RSAPrivateKey privateKey;
  final X509CertificateData certData;
  final String certB64;
  final String pemPrivateKey;
  final List<String> pemChain;

  /// Cria um [SecurityContext] configurado com o certificado A1.
  SecurityContext toSecurityContext({bool withTrustedRoots = true}) {
    if (pemChain.isEmpty) {
      throw StateError('Certificado sem cadeia válida para configurar TLS.');
    }

    final context = SecurityContext(withTrustedRoots: withTrustedRoots);

    final chainPem = pemChain
        .map((block) => block.trim())
        .where((block) => block.isNotEmpty)
        .join('\n');

    context.useCertificateChainBytes(utf8.encode(chainPem));
    context.usePrivateKeyBytes(utf8.encode(pemPrivateKey));

    return context;
  }
}

Future<CertBundle> loadPfx(String pfxBase64, String password) async {
  final pfxBytes = base64Decode(pfxBase64);
  final entries = Pkcs12Utils.parsePkcs12(pfxBytes, password: password);

  if (entries.isEmpty) {
    throw Exception('Nenhum conteúdo encontrado no arquivo PFX.');
  }

  String? pemKey;
  final pemCerts = <String>[];

  for (final entry in entries) {
    if (entry.contains('PRIVATE KEY')) {
      pemKey ??= entry;
    } else if (entry.contains('CERTIFICATE')) {
      pemCerts.add(entry);
    }
  }

  if (pemKey == null || pemCerts.isEmpty) {
    throw Exception('PFX não contém chave privada e certificado.');
  }

  final primaryCertPem = pemCerts.first;

  final privateKey = CryptoUtils.rsaPrivateKeyFromPem(pemKey);
  final certData = X509Utils.x509CertificateFromPem(primaryCertPem);

  final certB64 = primaryCertPem
      .replaceAll('-----BEGIN CERTIFICATE-----', '')
      .replaceAll('-----END CERTIFICATE-----', '')
      .replaceAll('\r', '')
      .replaceAll('\n', '')
      .trim();

  return CertBundle(
    privateKey: privateKey,
    certData: certData,
    certB64: certB64,
    pemPrivateKey: pemKey,
    pemChain: pemCerts,
  );
}
