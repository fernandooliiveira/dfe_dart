import 'package:dfe_dart/src/endereco_consulta_publica_nfce.dart';
import 'package:dfe_dart/src/enum/_init.dart';
import 'package:dfe_dart/src/nfe.dart';

class ExistNFeSupl {
  static List<EnderecoConsultaPublicaNfce> endQrCodeNfce = carregaUrls();

  ExistNFeSupl() {
    // endQrCodeNfce = carregaUrls();
  }

  static List<EnderecoConsultaPublicaNfce> carregaUrls() {
    List<EnderecoConsultaPublicaNfce> endQrCodeNfce = [];

    adicionaUrl({
      required ETipoAmbiente tipoAmbiente,
      required ETipoUrlConsultaPublica tipoUrlConsultaPublica,
      required List<EVersaoQrCode> versaoQrCode,
      required List<QrCodeUrls> enderecos,
    }) {
      for (var endereco in enderecos) {
        for (var qrCode in versaoQrCode) {
          for (var servico in endereco.servicos) {
            endQrCodeNfce.add(
              EnderecoConsultaPublicaNfce(
                tipoAmbiente: tipoAmbiente,
                estado: endereco.estado,
                tipoUrlConsultaPublica: tipoUrlConsultaPublica,
                versaoServico: servico,
                versaoQrCode: qrCode,
                url: endereco.url,
              ),
            );
          }
        }
      }
    }

    // final versao3 = [EVersaoServico.versao310];
    final versao4 = [EVersaoServico.versao400];
    final versao3e4 = [EVersaoServico.versao310, EVersaoServico.versao400];

    final urlsQrCodeProducaoQrCode1E2 = [
      QrCodeUrls(EEstado.ac, versao3e4, "http://www.sefaznet.ac.gov.br/nfce/qrcode?"),
      QrCodeUrls(EEstado.al, versao3e4, "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp"),
      QrCodeUrls(EEstado.ap, versao3e4, "https://www.sefaz.ap.gov.br/nfce/nfcep.php"),
      QrCodeUrls(EEstado.am, versao3e4, "http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?"),
      QrCodeUrls(EEstado.ba, versao3e4, "http://nfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx"),
      QrCodeUrls(EEstado.ce, versao3e4, "http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html"),
      QrCodeUrls(EEstado.go, versao3e4, "http://nfe.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe"),
      QrCodeUrls(EEstado.ma, versao3e4, "http://nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp"),
      QrCodeUrls(EEstado.mt, versao3e4, "http://www.sefaz.mt.gov.br/nfce/consultanfce"),
      QrCodeUrls(EEstado.ms, versao3e4, "http://www.dfe.ms.gov.br/nfce/qrcode?"),
      QrCodeUrls(EEstado.pa, versao3e4, "https://appnfc.sefa.pa.gov.br/portal/view/consultas/nfce/nfceForm.seam"),
      QrCodeUrls(EEstado.pb, versao3e4, "http://www.sefaz.pb.gov.br/nfce"),
      QrCodeUrls(EEstado.pe, versao3e4, "http://nfce.sefaz.pe.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.pi, versao3e4, "http://www.sefaz.pi.gov.br/nfce/qrcode"),
      QrCodeUrls(EEstado.rj, versao3e4, "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?"),
      QrCodeUrls(EEstado.rn, versao3e4, "http://nfce.set.rn.gov.br/consultarNFCe.aspx"),
      QrCodeUrls(EEstado.rs, versao3e4, "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx"),
      QrCodeUrls(EEstado.ro, versao3e4, "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp"),
      QrCodeUrls(EEstado.rr, versao3e4, "https://www.sefaz.rr.gov.br/nfce/servlet/qrcode"),
      QrCodeUrls(EEstado.mg, versao3e4, "https://portalsped.fazenda.mg.gov.br/portalnfce/sistema/qrcode.xhtml"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.producao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlQrCode,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao1, EVersaoQrCode.qrCodeVersao2],
      enderecos: urlsQrCodeProducaoQrCode1E2,
    );

    final urlsQrCodeProducaoQrCode1 = [
      QrCodeUrls(EEstado.df, versao3e4, "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx"),
      QrCodeUrls(EEstado.pr, versao3e4, "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?"),
      QrCodeUrls(EEstado.sp, versao3e4, "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx"),
      QrCodeUrls(EEstado.se, versao3e4, "http://www.nfce.se.gov.br/portal/consultarNFCe.jsp?"),
      QrCodeUrls(EEstado.to, versao3e4, "http://apps.sefaz.to.gov.br/portal-nfce/qrcodeNFCe"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.producao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlQrCode,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao1],
      enderecos: urlsQrCodeProducaoQrCode1,
    );

    final urlsQrCodeProducaoQrCode2 = [
      QrCodeUrls(EEstado.df, versao4, "http://www.fazenda.df.gov.br/nfce/qrcode?"),
      QrCodeUrls(EEstado.es, versao4, "http://app.sefaz.es.gov.br/ConsultaNFCe?"),
      QrCodeUrls(EEstado.pr, versao4, "http://www.fazenda.pr.gov.br/nfce/qrcode?"),
      QrCodeUrls(EEstado.sp, versao4, "https://www.nfce.fazenda.sp.gov.br/qrcode"),
      QrCodeUrls(EEstado.se, versao4, "http://www.nfce.se.gov.br/nfce/qrcode?"),
      QrCodeUrls(EEstado.to, versao4, "http://apps.sefaz.to.gov.br/portal-nfce/qrcodeNFCe"),
      QrCodeUrls(EEstado.sc, versao4, "https://sat.sef.sc.gov.br/nfce/consulta"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.producao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlQrCode,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao2],
      enderecos: urlsQrCodeProducaoQrCode2,
    );

    final urlsQrCodeHomologacaoQrCode1E2 = [
      QrCodeUrls(EEstado.ac, versao3e4, "http://www.hml.sefaznet.ac.gov.br/nfce/qrcode?"),
      QrCodeUrls(EEstado.al, versao3e4, "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp"),
      QrCodeUrls(EEstado.ap, versao3e4, "https://www.sefaz.ap.gov.br/nfcehml/nfce.php"),
      QrCodeUrls(EEstado.am, versao3e4, "https://sistemas.sefaz.am.gov.br/nfceweb-hom/consultarNFCe.jsp?"),
      QrCodeUrls(EEstado.ba, versao3e4, "http://hnfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx"),
      QrCodeUrls(EEstado.ce, versao3e4, "http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html"),
      QrCodeUrls(EEstado.df, versao3e4, "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx"),
      QrCodeUrls(EEstado.es, versao3e4, "http://homologacao.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?"),
      QrCodeUrls(EEstado.go, versao3e4, "http://homolog.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe"),
      QrCodeUrls(EEstado.ma, versao3e4, "http://www.hom.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp"),
      QrCodeUrls(EEstado.mt, versao3e4, "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce"),
      QrCodeUrls(EEstado.ms, versao3e4, "http://www.dfe.ms.gov.br/nfce/qrcode?"),
      QrCodeUrls(EEstado.pa, versao3e4, "https://appnfc.sefa.pa.gov.br/portal-homologacao/view/consultas/nfce/nfceForm.seam"),
      QrCodeUrls(EEstado.pb, versao3e4, "http://www.sefaz.pb.gov.br/nfcehom"),
      QrCodeUrls(EEstado.pe, versao3e4, "http://nfcehomolog.sefaz.pe.gov.br/nfce-web/consultarNFCe"),
      QrCodeUrls(EEstado.pi, versao3e4, "http://webas.sefaz.pi.gov.br/nfceweb-homologacao/consultarNFCe.jsf"),
      QrCodeUrls(EEstado.rj, versao3e4, "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?"),
      QrCodeUrls(EEstado.rn, versao3e4, "http://hom.nfce.set.rn.gov.br/consultarNFCe.aspx"),
      QrCodeUrls(EEstado.rs, versao3e4, "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx"),
      QrCodeUrls(EEstado.ro, versao3e4, "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.homologacao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlQrCode,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao1, EVersaoQrCode.qrCodeVersao2],
      enderecos: urlsQrCodeHomologacaoQrCode1E2,
    );

    final urlsQrCodeHomologacaoQrCode1 = [
      QrCodeUrls(EEstado.pr, versao3e4, "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?"),
      QrCodeUrls(EEstado.se, versao3e4, "http://www.hom.nfe.se.gov.br/portal/consultarNFCe.jsp?"),
      QrCodeUrls(EEstado.sp, versao3e4, "https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.homologacao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlQrCode,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao1],
      enderecos: urlsQrCodeHomologacaoQrCode1,
    );

    final urlsQrCodeHomologacaoQrCode2 = [
      QrCodeUrls(EEstado.pr, versao4, "http://www.fazenda.pr.gov.br/nfce/qrcode?"),
      QrCodeUrls(EEstado.se, versao4, "http://www.hom.nfe.se.gov.br/nfce/qrcode?"),
      QrCodeUrls(EEstado.sp, versao4, "https://www.homologacao.nfce.fazenda.sp.gov.br/qrcode"),
      QrCodeUrls(EEstado.sc, versao4, "https://hom.sat.sef.sc.gov.br/nfce/consulta"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.homologacao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlQrCode,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao2],
      enderecos: urlsQrCodeHomologacaoQrCode2,
    );

    final urlsConsultaProducao1 = [
      QrCodeUrls(EEstado.ac, versao3e4, "www.sefaznet.ac.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.al, versao3e4, "http://nfce.sefaz.al.gov.br/consultaNFCe.htm"),
      QrCodeUrls(EEstado.ap, versao3e4, "https://www.sefaz.ap.gov.br/sate/seg/SEGf_AcessarFuncao.jsp?cdFuncao=FIS_1261"),
      QrCodeUrls(EEstado.am, versao3e4, "sistemas.sefaz.am.gov.br/nfceweb/formConsulta.do"),
      QrCodeUrls(EEstado.ba, versao3e4, "nfe.sefaz.ba.gov.br/servicos/nfce/default.aspx"),
      QrCodeUrls(EEstado.df, versao3e4, "http://dec.fazenda.df.gov.br/NFCE/"),
      QrCodeUrls(EEstado.es, versao3e4, "http://app.sefaz.es.gov.br/ConsultaNFCe"),
      QrCodeUrls(EEstado.ma, versao3e4, "http://www.nfce.sefaz.ma.gov.br/portal/consultaNFe.do?method=preFilterCupom&"),
      QrCodeUrls(EEstado.mt, versao3e4, "http://www.sefaz.mt.gov.br/nfce/consultanfce"),
      QrCodeUrls(EEstado.ms, versao3e4, "http://www.dfe.ms.gov.br/nfce"),
      QrCodeUrls(EEstado.pa, versao3e4, "https://appnfc.sefa.pa.gov.br/portal/view/consultas/nfce/consultanfce.seam"),
      QrCodeUrls(EEstado.pb, versao3e4, "www.receita.pb.gov.br/nfce"),
      QrCodeUrls(EEstado.pr, versao3e4, "http://www.fazenda.pr.gov.br"),
      QrCodeUrls(EEstado.pi, versao3e4, "http://webas.sefaz.pi.gov.br/nfceweb/consultarNFCe.jsf"),
      QrCodeUrls(EEstado.rj, versao3e4, "www.nfce.fazenda.rj.gov.br/consulta"),
      QrCodeUrls(EEstado.rn, versao3e4, "http://nfce.set.rn.gov.br/consultarNFCe.aspx"),
      QrCodeUrls(EEstado.rs, versao3e4, "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx"),
      QrCodeUrls(EEstado.ro, versao3e4, "http://www.nfce.sefin.ro.gov.br"),
      QrCodeUrls(EEstado.rr, versao3e4, "https://www.sefaz.rr.gov.br/nfce/servlet/wp_consulta_nfce"),
      QrCodeUrls(EEstado.sp, versao3e4, "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica"),
      QrCodeUrls(EEstado.se, versao3e4, "http://www.nfce.se.gov.br/portal/portalNoticias.jsp"),
      QrCodeUrls(EEstado.to, versao3e4, "http://apps.sefaz.to.gov.br/portal-nfce/consultarNFCe.jsf"),
      QrCodeUrls(EEstado.go, versao4, "http://www.nfce.go.gov.br/post/ver/214344/consulta-nfce"),
      QrCodeUrls(EEstado.pe, versao4, "http://nfce.sefaz.pe.gov.br/nfce-web/consultarNFCe"),
      QrCodeUrls(EEstado.mg, versao3e4, "https://portalsped.fazenda.mg.gov.br/portalnfce"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.producao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlConsulta,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao1],
      enderecos: urlsConsultaProducao1,
    );

    final urlsConsultaHomologacao1 = [
      QrCodeUrls(EEstado.ac, versao3e4, "http://hml.sefaznet.ac.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.al, versao3e4, "http://nfce.sefaz.al.gov.br/consultaNFCe.htm"),
      QrCodeUrls(EEstado.ap, versao3e4, "https://www.sefaz.ap.gov.br/sate1/seg/SEGf_AcessarFuncao.jsp?cdFuncao=FIS_1261"),
      QrCodeUrls(EEstado.am, versao3e4, "http://homnfce.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?"),
      QrCodeUrls(EEstado.ba, versao3e4, "http://hnfe.sefaz.ba.gov.br/servicos/nfce/default.aspx"),
      QrCodeUrls(EEstado.ce, versao3e4, "http://nfceh.sefaz.ce.gov.br/pages/consultaNota.jsf"),
      QrCodeUrls(EEstado.df, versao3e4, "http://dec.fazenda.df.gov.br/NFCE/"),
      QrCodeUrls(EEstado.es, versao3e4, "http://homologacao.sefaz.es.gov.br/ConsultaNFCe"),
      QrCodeUrls(EEstado.ma, versao3e4, "http://www.hom.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp"),
      QrCodeUrls(EEstado.mt, versao3e4, "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce"),
      QrCodeUrls(EEstado.ms, versao3e4, "http://www.dfe.ms.gov.br/nfce"),
      QrCodeUrls(EEstado.pa, versao3e4, "https://appnfc.sefa.pa.gov.br/portal-homologacao/view/consultas/nfce/consultanfce.seam"),
      QrCodeUrls(EEstado.pb, versao3e4, "http://www.sefaz.pb.gov.br/nfcehom"),
      QrCodeUrls(EEstado.pr, versao3e4, "http://www.fazenda.pr.gov.br"),
      QrCodeUrls(EEstado.pi, versao3e4, "http://webas.sefaz.pi.gov.br/nfceweb-homologacao/consultarNFCe.jsf"),
      QrCodeUrls(EEstado.rj, versao3e4, "www.nfce.fazenda.rj.gov.br/consulta"),
      QrCodeUrls(EEstado.rn, versao3e4, "http://nfce.set.rn.gov.br/consultarNFCe.aspx"),
      QrCodeUrls(EEstado.rs, versao3e4, "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx"),
      QrCodeUrls(EEstado.ro, versao3e4, "http://www.nfce.sefin.ro.gov.br"),
      QrCodeUrls(EEstado.rr, versao3e4, "http://200.174.88.103:8080/nfce/servlet/wp_consulta_nfce"),
      QrCodeUrls(EEstado.sp, versao3e4, "https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica"),
      QrCodeUrls(EEstado.se, versao3e4, "http://www.hom.nfe.se.gov.br/portal/portalNoticias.jsp"),
      QrCodeUrls(EEstado.to, versao3e4, "http://apps.sefaz.to.gov.br/portal-nfce-homologacao/consultarNFCe.jsf"),
      QrCodeUrls(EEstado.go, versao4,   "http://www.nfce.go.gov.br/post/ver/214413/consulta-nfc-e-homologacao?"),
      QrCodeUrls(EEstado.pe, versao4,   "http://nfcehomolog.sefaz.pe.gov.br/nfce-web/consultarNFCe"),
      QrCodeUrls(EEstado.mg, versao3e4, "https://hportalsped.fazenda.mg.gov.br/portalnfce"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.homologacao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlConsulta,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao1],
      enderecos: urlsConsultaHomologacao1,
    );

    final urlsConsultaHomologacaoEProducao2 = [
      QrCodeUrls(EEstado.ac, versao3e4, "www.sefaznet.ac.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.al, versao3e4, "www.sefaz.al.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.ap, versao3e4, "www.sefaz.ap.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.am, versao3e4, "www.sefaz.am.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.ce, versao3e4, "www.sefaz.ce.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.df, versao3e4, "www.fazenda.df.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.es, versao3e4, "www.sefaz.es.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.ma, versao3e4, "www.sefaz.ma.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.ms, versao3e4, "http://www.dfe.ms.gov.br/nfce"),
      QrCodeUrls(EEstado.pa, versao3e4, "www.sefa.pa.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.pr, versao3e4, "http://www.fazenda.pr.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.pe, versao3e4, "nfce.sefaz.pe.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.pi, versao3e4, "www.sefaz.pi.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.rj, versao3e4, "www.fazenda.rj.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.rn, versao3e4, "www.set.rn.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.rs, versao3e4, "www.sefaz.rs.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.ro, versao3e4, "www.sefin.ro.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.rr, versao3e4, "www.sefaz.rr.gov.br/nfce/consulta"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.homologacao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlConsulta,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao2],
      enderecos: urlsConsultaHomologacaoEProducao2,
    );
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.producao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlConsulta,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao2],
      enderecos: urlsConsultaHomologacaoEProducao2,
    );

    final urlsConsultaProducao2 = [
      QrCodeUrls(EEstado.ba, versao3e4, "www.sefaz.ba.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.mt, versao3e4, "http://www.sefaz.mt.gov.br/nfce/consultanfce"),
      QrCodeUrls(EEstado.pb, versao3e4, "www.receita.pb.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.sp, versao3e4, "https://www.nfce.fazenda.sp.gov.br/consulta"),
      QrCodeUrls(EEstado.se, versao3e4, "http://www.nfce.se.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.go, versao3e4, "www.sefaz.go.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.mg, versao3e4, "https://portalsped.fazenda.mg.gov.br/portalnfce"),
      QrCodeUrls(EEstado.to, versao3e4, "www.sefaz.to.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.sc, versao3e4, "https://sat.sef.sc.gov.br/nfce/consulta"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.producao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlConsulta,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao2],
      enderecos: urlsConsultaProducao2,
    );

    final urlsConsultaHomologacao2 = [
      QrCodeUrls(EEstado.ba, versao3e4, "http://hinternet.sefaz.ba.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.mt, versao3e4, "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce"),
      QrCodeUrls(EEstado.pb, versao3e4, "www.receita.pb.gov.br/nfcehom"),
      QrCodeUrls(EEstado.sp, versao3e4, "https://www.homologacao.nfce.fazenda.sp.gov.br/consulta"),
      QrCodeUrls(EEstado.se, versao3e4, "http://www.hom.nfe.se.gov.br/nfce/consulta"),
      QrCodeUrls(EEstado.go, versao3e4, "http://homolog.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe"),
      QrCodeUrls(EEstado.mg, versao3e4, "https://hportalsped.fazenda.mg.gov.br/portalnfce"),
      QrCodeUrls(EEstado.to, versao3e4, "http://homologacao.sefaz.to.gov.br/nfce/consulta.jsf"),
      QrCodeUrls(EEstado.sc, versao3e4, "https://hom.sat.sef.sc.gov.br/nfce/consulta"),
    ];
    adicionaUrl(
      tipoAmbiente: ETipoAmbiente.homologacao,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlConsulta,
      versaoQrCode: [EVersaoQrCode.qrCodeVersao2],
      enderecos: urlsConsultaHomologacao2,
    );

    return endQrCodeNfce;
  }

  static String obterUrl({
    required ETipoAmbiente tipoAmbiente,
    required EEstado estado,
    required ETipoUrlConsultaPublica tipoUrlConsultaPublica,
    required EVersaoServico versaoServico,
    required EVersaoQrCode versaoQrCode,
  }) {
    final query = endQrCodeNfce.where((qr) => qr.tipoAmbiente == tipoAmbiente &&
        qr.estado == estado &&
        qr.tipoUrlConsultaPublica == tipoUrlConsultaPublica &&
        qr.versaoServico == versaoServico &&
        qr.versaoQrCode == versaoQrCode).map((e) => e.url).toList();
    final qtdRetorno = query.length;
    if(qtdRetorno == 0) {
      throw Exception("Não foi possível obter o ${tipoUrlConsultaPublica.description}, para o Estado ${estado.name}, ambiente: ${tipoAmbiente.description}");
    }
    if(qtdRetorno > 1) {
      throw Exception("A função ObterUrl obteve mais de um resultado");
    }
    return query.first;
  }

  static String obterUrlConsulta({
    required Nfe nfe,
    required EVersaoQrCode versaoQrCode,
    // required String cIdToken,
    // required String csc,
  }) {
    return obterUrl(
      tipoAmbiente: nfe.infNfce.ide.tpAmb,
      estado: nfe.infNfce.ide.cUF,
      tipoUrlConsultaPublica: ETipoUrlConsultaPublica.urlConsulta,
      versaoServico: nfe.infNfce.versao,
      versaoQrCode: versaoQrCode,
    );
  }
}

class QrCodeUrls {
  final EEstado estado;
  final List<EVersaoServico> servicos;
  final String url;

  QrCodeUrls(this.estado, this.servicos, this.url);
}
