import 'package:xml_sign_dart/src/entidades/cons_cad.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';

Future<void> executarConsultaCadastro(OperacaoContexto contexto) async {
  final xmlConsCad = ConsCad(
    infCons: InfCons(uf: contexto.uf, cnpj: contexto.cnpjEmitente),
  ).toXmlString();

  await contexto.executarOperacao(
    'Consulta cadastro contribuinte',
    () => enviarConsultaCadastro(
      xmlConsCad: xmlConsCad,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      certificado: contexto.certBundle,
    ),
  );
}
