import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';

Future<void> executarEnvioNfce(OperacaoContexto contexto) async {
  await contexto.executarOperacao(
    'Envio NFC-e modelo 65',
    () => enviarNFe(
      xmlAssinado: contexto.xmlNfceAssinada,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
