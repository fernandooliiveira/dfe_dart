import 'package:xml_sign_dart/src/assinar.dart';
import 'package:xml_sign_dart/src/certificado.dart';
import 'package:xml_sign_dart/src/entidades/nfe.dart';
import 'package:xml_sign_dart/src/qr_code.dart';
import 'package:xml_sign_dart/src/sefaz_endpoints.dart';

/// Helper para facilitar operações com NFe
class NFeHelper {
  final CertBundle certificado;
  final HashAlgo algoritmoAssinatura;

  NFeHelper({
    required this.certificado,
    this.algoritmoAssinatura = HashAlgo.sha256,
  });

  /// Assina uma NFe
  NFe assinar(NFe nfe) {
    return assinarNFe(nfe: nfe, cert: certificado, algo: algoritmoAssinatura);
  }

  /// Assina e adiciona QRCode (para NFC-e)
  NFe assinarComQRCode({
    required NFe nfe,
    required String uf,
    required Ambiente ambiente,
    required String idCSC,
    required String csc,
  }) {
    // 1. Obter URLs do endpoint
    final endpoints = SefazEndpoints.getEndpoints(
      tipo: TipoDocumento.nfce,
      uf: uf,
      ambiente: ambiente,
    );

    final urlQRCode = endpoints[SefazServico.urlQrCode];
    final urlConsulta = endpoints[SefazServico.urlConsultaNfce];

    if (urlQRCode == null || urlConsulta == null) {
      throw Exception('URLs de QRCode não encontradas para UF $uf');
    }

    // 2. Extrair chave da NFe do Id
    final chaveNFe = nfe.infNFe.id.replaceFirst('NFe', '');

    // 3. Gerar QRCode
    final qrCode = gerarQRCodeNFCe(
      urlBase: urlQRCode,
      chaveNFe: chaveNFe,
      versao: '100',
      tpAmb: nfe.infNFe.ide.tpAmb,
      idCSC: idCSC,
      csc: csc,
    );

    // 4. Adicionar infNFeSupl
    final nfeComQR = NFe(
      infNFe: nfe.infNFe,
      signature: nfe.signature,
      infNFeSupl: InfNFeSupl(qrCode: qrCode, urlChave: urlConsulta),
    );

    // 5. Assinar
    return assinar(nfeComQR);
  }

  /// Prepara uma NFe para envio (assina e valida)
  Future<NFe> prepararParaEnvio(NFe nfe) async {
    // Validações básicas
    _validarNFe(nfe);

    // Assinar
    final nfeAssinada = assinar(nfe);

    return nfeAssinada;
  }

  /// Valida campos obrigatórios da NFe
  void _validarNFe(NFe nfe) {
    if (nfe.infNFe.id.isEmpty) {
      throw Exception('Id da NFe é obrigatório');
    }

    if (nfe.infNFe.emit.cnpj.isEmpty) {
      throw Exception('CNPJ do emitente é obrigatório');
    }

    if (nfe.infNFe.det.isEmpty) {
      throw Exception('NFe deve ter pelo menos um item');
    }

    if (nfe.infNFe.ide.mod != '55' && nfe.infNFe.ide.mod != '65') {
      throw Exception('Modelo deve ser 55 (NFe) ou 65 (NFCe)');
    }
  }

  /// Assina um lote de NFes
  List<NFe> assinarLote(List<NFe> nfes) {
    return assinarLoteNFe(
      nfes: nfes,
      cert: certificado,
      algo: algoritmoAssinatura,
    );
  }
}
