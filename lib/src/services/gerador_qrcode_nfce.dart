import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:qr/qr.dart';
import 'package:xml/xml.dart';

import '../enum/_init.dart';
import '../models/extinf_nfe_supl.dart';

/// Gerador de QR Code para NFC-e conforme NT 2015.002 v1.22.
///
/// Fluxo típico:
/// ```dart
/// // 1. Gerar e assinar o XML
/// final xmlAssinado = assinador.assinar(nfe.toXmlString());
///
/// // 2. Montar a URL do QR Code
/// final urlQr = GeradorQrCodeNfce.gerarUrlDaNfe(
///   nfe: nfe,
///   xmlAssinado: xmlAssinado,
///   urlBase: ExtInfNFeSupl.obterUrl(...),
///   cIdToken: '000001',
///   csc: 'SEU_CSC_AQUI',
/// );
///
/// // 3. Gerar SVG para impressão
/// final svg = GeradorQrCodeNfce.gerarSvg(urlQr);
/// ```
class GeradorQrCodeNfce {
  GeradorQrCodeNfce._();

  // Epoch de referência PKCS#12 / NT 2015.002: 2000-01-01T00:00:00Z
  static final _epoch2000 = DateTime.utc(2000, 1, 1);

  /// Monta a URL do QR Code a partir dos parâmetros individuais.
  ///
  /// - [urlBase]   URL base da SEFAZ para o estado (com ou sem `?` final).
  /// - [chNFe]     Chave de acesso (44 dígitos).
  /// - [tpAmb]     1 = produção, 2 = homologação.
  /// - [cpfDest]   CPF do destinatário (só dígitos), ou null se não identificado.
  /// - [dhEmi]     Data/hora de emissão da NFC-e.
  /// - [vNF]       Valor total da NF.
  /// - [vICMS]     Valor do ICMS.
  /// - [digVal]    DigestValue da assinatura (string base64 extraída do XML).
  /// - [cIdToken]  Identificador do CSC (ex.: "000001").
  /// - [csc]       Código de segurança do contribuinte (CSC).
  static String gerarUrl({
    required String urlBase,
    required String chNFe,
    required int tpAmb,
    String? cpfDest,
    required DateTime dhEmi,
    required double vNF,
    required double vICMS,
    required String digVal,
    required String cIdToken,
    required String csc,
  }) {
    // Garante separador de query string
    final base = (urlBase.endsWith('?') || urlBase.endsWith('&'))
        ? urlBase
        : '$urlBase?';

    // dhEmi → segundos desde 2000-01-01T00:00:00Z, em hex uppercase
    final dhEmiSecs = dhEmi.toUtc().difference(_epoch2000).inSeconds;
    final dhEmiHex = dhEmiSecs.toRadixString(16).toUpperCase();

    // Valores monetários → centavos → hex uppercase
    final vNFHex = (vNF * 100).round().toRadixString(16).toUpperCase();
    final vICMSHex = (vICMS * 100).round().toRadixString(16).toUpperCase();

    // cIdToken com 6 dígitos, zero-padded
    final tokenPadded = cIdToken.padLeft(6, '0');

    // digVal: base64 precisa ser URL-encoded (+ → %2B, = → %3D, / → %2F)
    final digValEnc = Uri.encodeComponent(digVal);

    // cDest é opcional
    final destParam =
        (cpfDest != null && cpfDest.isNotEmpty) ? '&cDest=$cpfDest' : '';

    // URL completa sem o hash
    final urlSemHash = '${base}chNFe=$chNFe'
        '&nVersao=100'
        '&tpAmb=$tpAmb'
        '$destParam'
        '&dhEmi=$dhEmiHex'
        '&vNF=$vNFHex'
        '&vICMS=$vICMSHex'
        '&digVal=$digValEnc'
        '&cIdToken=$tokenPadded';

    // cHashQRCode = SHA-1( urlSemHash + csc ) em hex uppercase
    final cHash = _sha1Hex(urlSemHash + csc);

    return '$urlSemHash&cHashQRCode=$cHash';
  }

  /// Extrai automaticamente os parâmetros de um XML de NFC-e já assinado e
  /// gera a URL do QR Code.
  ///
  /// Extrai `chNFe` (atributo `Id` sem "NFe"), `tpAmb`, `dhEmi`, `vNF`,
  /// `vICMS` e `digVal` diretamente do XML.
  static String gerarUrlDaNfe({
    required String xmlAssinado,
    required String urlBase,
    required String cIdToken,
    required String csc,
    String? cpfDest,
  }) {
    final doc = XmlDocument.parse(xmlAssinado);
    final root = doc.rootElement;

    // Chave de acesso: atributo Id do infNFe (começa com "NFe")
    final infNfe = root.findAllElements('infNFe').first;
    final id = infNfe.getAttribute('Id') ?? '';
    final chNFe = id.startsWith('NFe') ? id.substring(3) : id;

    // Tipo ambiente
    final tpAmbStr = infNfe.findElements('ide').first
        .findElements('tpAmb').first.innerText;
    final tpAmb = int.parse(tpAmbStr);

    // Data/hora emissão
    final dhEmiStr = infNfe.findElements('ide').first
        .findElements('dhEmi').first.innerText;
    final dhEmi = DateTime.parse(dhEmiStr);

    // Valor total NF
    final vNFStr = infNfe.findAllElements('vNF').first.innerText;
    final vNF = double.parse(vNFStr);

    // Valor ICMS total
    final vICMSStr = infNfe.findAllElements('vICMS').first.innerText;
    final vICMS = double.parse(vICMSStr);

    // DigestValue da assinatura
    final digVal =
        doc.findAllElements('DigestValue').first.innerText.trim();

    return gerarUrl(
      urlBase: urlBase,
      chNFe: chNFe,
      tpAmb: tpAmb,
      cpfDest: cpfDest,
      dhEmi: dhEmi,
      vNF: vNF,
      vICMS: vICMS,
      digVal: digVal,
      cIdToken: cIdToken,
      csc: csc,
    );
  }

  /// Retorna a matriz de módulos do QR Code.
  ///
  /// `matrix[row][col] == true` → módulo escuro (pixel preto).
  /// Nível de correção de erro: M (conforme NT 2015.002).
  static List<List<bool>> gerarMatriz(String url) {
    final qrCode = QrCode.fromData(
      data: url,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );
    final qrImage = QrImage(qrCode);
    final n = qrCode.moduleCount;
    return List.generate(
        n, (row) => List.generate(n, (col) => qrImage.isDark(row, col)));
  }

  /// Gera o QR Code como string SVG.
  ///
  /// [size] dimensão em pixels do SVG gerado (quadrado).
  static String gerarSvg(String url, {int size = 200}) {
    final matrix = gerarMatriz(url);
    final n = matrix.length;
    // Pixel size como double para minimizar arredondamento
    final ps = size / n;

    final sb = StringBuffer()
      ..write('<svg xmlns="http://www.w3.org/2000/svg" '
          'width="$size" height="$size" viewBox="0 0 $size $size">')
      ..write('<rect width="$size" height="$size" fill="white"/>');

    for (var row = 0; row < n; row++) {
      for (var col = 0; col < n; col++) {
        if (matrix[row][col]) {
          final x = _fmt(col * ps);
          final y = _fmt(row * ps);
          final s = _fmt(ps);
          sb.write('<rect x="$x" y="$y" width="$s" height="$s" fill="black"/>');
        }
      }
    }
    sb.write('</svg>');
    return sb.toString();
  }

  /// Versão integrada que lê o XML assinado, detecta o modo de emissão
  /// (`tpEmis`) e seleciona automaticamente a URL base correta via
  /// [ExtInfNFeSupl]:
  ///
  /// - `tpEmis = 1` (normal) → `EVersaoQrCode.qrCodeVersao1`
  /// - `tpEmis = 9` (offline/contingência) → `EVersaoQrCode.qrCodeVersao2`
  ///
  /// Para emissões em contingência o XML deve estar **assinado localmente**
  /// antes desta chamada (a assinatura fornece o `digVal`). A transmissão
  /// à SEFAZ pode ser feita depois que a conexão for restabelecida.
  static String gerarUrlCompleto({
    required String xmlAssinado,
    required String cIdToken,
    required String csc,
    String? cpfDest,
  }) {
    final doc = XmlDocument.parse(xmlAssinado);
    final root = doc.rootElement;
    final infNfe = root.findAllElements('infNFe').first;
    final ideEl = infNfe.findElements('ide').first;

    // Tipo de emissão: 1 = normal, 9 = offline/contingência
    final tpEmisStr = ideEl.findElements('tpEmis').isNotEmpty
        ? ideEl.findElements('tpEmis').first.innerText
        : '1';
    final versaoQrCode = tpEmisStr == '9'
        ? EVersaoQrCode.qrCodeVersao2
        : EVersaoQrCode.qrCodeVersao1;

    // Ambiente e estado
    final tpAmbStr = ideEl.findElements('tpAmb').first.innerText;
    final tipoAmbiente = tpAmbStr == '1'
        ? ETipoAmbiente.producao
        : ETipoAmbiente.homologacao;

    final cUFStr = ideEl.findElements('cUF').first.innerText;
    final estado = EEstado.values.firstWhere((e) => e.codigo == cUFStr);

    // Versão do serviço
    final versaoAttr = infNfe.getAttribute('versao') ?? '4.00';
    final versaoServico = versaoAttr.startsWith('3')
        ? EVersaoServico.versao310
        : EVersaoServico.versao400;

    // URL base via lookup de estado
    final urlBase = ExtInfNFeSupl.obterUrl(
      tipoAmbiente: tipoAmbiente,
      estado: estado,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlQrCode,
      versaoServico: versaoServico,
      versaoQrCode: versaoQrCode,
    );

    return gerarUrlDaNfe(
      xmlAssinado: xmlAssinado,
      urlBase: urlBase,
      cIdToken: cIdToken,
      csc: csc,
      cpfDest: cpfDest,
    );
  }

  // ─── helpers ──────────────────────────────────────────────────────────────

  static String _sha1Hex(String input) {
    final data = utf8.encode(input);
    final sha1 = SHA1Digest();
    final out = Uint8List(sha1.digestSize);
    sha1
      ..update(Uint8List.fromList(data), 0, data.length)
      ..doFinal(out, 0);
    return out
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
  }

  static String _fmt(double v) => v.toStringAsFixed(2);
}
