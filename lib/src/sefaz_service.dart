import 'package:xml_sign_dart/src/sefaz_endpoints.dart';

class SefazService {
  final _cache = <String, Map<SefazServico, String>>{};

  Map<SefazServico, String> getEndpoints({
    required String uf,
    required TipoDocumento tipo,
    required Ambiente ambiente,
  }) {
    final key = '$uf-${tipo.name}-${ambiente.name}';

    return _cache.putIfAbsent(key, () {
      return SefazEndpoints.getEndpoints(
        tipo: tipo,
        uf: uf,
        ambiente: ambiente,
      );
    });
  }

  String? getUrl({
    required String uf,
    required TipoDocumento tipo,
    required Ambiente ambiente,
    required SefazServico servico,
  }) {
    final endpoints = getEndpoints(uf: uf, tipo: tipo, ambiente: ambiente);
    return endpoints[servico];
  }
}
