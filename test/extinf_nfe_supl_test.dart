import 'package:dfe_dart/dfe_dart.dart';
import 'package:dfe_dart/src/enum/_init.dart';
import 'package:dfe_dart/src/ide.dart';
import 'package:dfe_dart/src/inf_nfce.dart';
import 'package:dfe_dart/src/nfe.dart';
import 'package:test/test.dart';

//teste
void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Teste para URL de homologação para o estado de Goiás(GO)', () {
      final nfe = Nfe(
        infNfce: InfNfce(
          ide: Ide(tpAmb: ETipoAmbiente.homologacao, cUF: EEstado.go),
          versao: EVersaoServico.versao400,
        ),
      );

      final url = ExistNFeSupl.obterUrlConsulta(
        nfe: nfe,
        versaoQrCode: EVersaoQrCode.qrCodeVersao1,
        // cIdToken: cIdToken,
        // csc: csc,
      );
      print(url);
      // X509Certificate
      // expect(awesome.isAwesome, isTrue);
    });
  });
}
