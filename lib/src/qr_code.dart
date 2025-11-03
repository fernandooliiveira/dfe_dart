import 'dart:convert';
import 'package:crypto/crypto.dart';

String gerarQRCodeNFCe({
  required String urlBase,
  required String chaveNFe,
  required String versao,
  required String tpAmb,
  required String idCSC,
  required String csc,
}) {
  // Monta a parte antes do hash
  final conteudo = '$chaveNFe|$versao|$tpAmb|$idCSC';

  // Gera o hash HMAC-SHA1
  final hmac = Hmac(sha1, utf8.encode(csc));
  final digest = hmac.convert(utf8.encode(conteudo)).toString().toUpperCase();

  // Concatena tudo
  final url = '$urlBase?p=$chaveNFe|$versao|$tpAmb|$idCSC|$digest';

  return url;
}
