import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Exceção lançada quando a SEFAZ retorna HTTP != 200 ou quando há erro de rede.
class SefazException implements Exception {
  final String message;
  final int? httpStatus;
  const SefazException(this.message, {this.httpStatus});
  @override
  String toString() => 'SefazException: $message';
}

/// Cliente HTTP com mTLS para comunicação com os WebServices da SEFAZ.
///
/// A autenticação mútua TLS (mTLS) é obrigatória para todos os serviços da SEFAZ.
/// Este cliente usa [dart:io] [HttpClient] com [SecurityContext] configurado com
/// o certificado A1 (PEM) e a chave privada PKCS#8 (PEM).
///
/// Uso:
/// ```dart
/// final pfxResult = AssinadorXml.parsePfx(pfxBytes, senha);
/// final client = SefazClient.fromPkcs12(pfxResult.pkcs8Der, pfxResult.certDer);
/// final resp = await client.post(url, soapEnvelope);
/// client.close();
/// ```
class SefazClient {
  final HttpClient _http;

  SefazClient._(this._http);

  /// Cria o cliente com mTLS a partir dos bytes PKCS#8 DER (chave privada)
  /// e do certificado DER — ambos extraídos pelo [Pkcs12Reader].
  factory SefazClient.fromPkcs12(Uint8List pkcs8Der, Uint8List certDer) {
    final certPem = _toPem(certDer, 'CERTIFICATE');
    final keyPem = _toPem(pkcs8Der, 'PRIVATE KEY');

    final ctx = SecurityContext()
      ..useCertificateChainBytes(utf8.encode(certPem))
      ..usePrivateKeyBytes(utf8.encode(keyPem));

    final http = HttpClient(context: ctx)
      // Em produção mantenha false; para testes de homologação com cert auto-assinado
      // da SEFAZ, alguns estados precisam de true. Ajuste conforme necessário.
      ..badCertificateCallback = (_, __, ___) => false;

    return SefazClient._(http);
  }

  /// Faz um POST SOAP 1.2 e retorna o corpo da resposta como string.
  ///
  /// Lança [SefazException] em caso de erro HTTP ou de rede.
  Future<String> post(String url, String soapEnvelope) async {
    final uri = Uri.parse(url);
    final body = utf8.encode(soapEnvelope);

    final request = await _http.postUrl(uri);
    request.headers
      ..set(HttpHeaders.contentTypeHeader,
          'application/soap+xml; charset=utf-8')
      ..set(HttpHeaders.contentLengthHeader, body.length.toString());
    request.add(body);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode != 200) {
      throw SefazException(
        'HTTP ${response.statusCode} ao chamar $url\n$responseBody',
        httpStatus: response.statusCode,
      );
    }

    return responseBody;
  }

  /// Fecha o cliente HTTP. Chame ao terminar as requisições para liberar recursos.
  void close({bool force = false}) => _http.close(force: force);

  // ─── DER → PEM ───────────────────────────────────────────────────────────

  static String _toPem(Uint8List der, String label) {
    final b64 = base64.encode(der);
    final sb = StringBuffer()..writeln('-----BEGIN $label-----');
    for (var i = 0; i < b64.length; i += 64) {
      sb.writeln(b64.substring(i, (i + 64).clamp(0, b64.length)));
    }
    sb.write('-----END $label-----');
    return sb.toString();
  }
}
