import 'package:dfe_dart/src/enum/_init.dart';
import 'package:dfe_dart/src/extensions/date_time_extension.dart';
import 'package:dfe_dart/src/nfe.dart';


class Ide {
  EEstado cUF;
  String? cNF;
  String? natOp;
  EIndicadorPagamento? indPag;
  bool get indPagSpecified => indPag != null;
  EModeloDocumento? mod;
  int serie = 0;
  int nNF = 0;
  DateTime dEmi = DateTime.now();
  DateTime dSaiEnt = DateTime.now();
  DateTime dhEmi = DateTime.now();
  DateTime? dhSaiEnt;
  ETipoNfe? tpNF;
  EDestinoOperacao? idDest;
  int cMunFG = 0;
  ETipoImpressao? tpImp;
  ETipoEmissao? tpEmis;
  int cDV = 0;
  ETipoAmbiente tpAmb;
  EFinalidadeNFe? finNFe;
  EConsumidorFinal? indFinal;
  EPresencaComprador? indPres;
  EIndicadorIntermediador? indIntermed;
  bool get indIntermedSpecified => indIntermed != null;
  ProcessoEmissao? procEmi;
  String? verProc;
  DateTime dhCont = DateTime.now();
  String? xJust;
  List<Nfe>? nFref;

  Ide({required this.tpAmb, required this.cUF});

  String get proxydhSaiEnt => dhSaiEnt!.paraDataStringUtc();
  set proxydhSaiEnt(String value) => dhSaiEnt = DateTime.parse(value);

  String get proxyDhEmi => dhEmi.paraDataStringUtc();
  set proxyDhEmi(String value) => dhEmi = DateTime.parse(value);

  String get proxydEmi => dEmi.paraDataString();
  set proxydEmi(String value) => dEmi = DateTime.parse(value);

  String get proxydSaiEnt => dSaiEnt.paraDataString();
  set proxydSaiEnt(String value) => dSaiEnt = DateTime.parse(value);

  String get proxydhCont => dhCont.paraDataStringUtc();
  set proxydhCont(String value) => dhCont = DateTime.parse(value);


  bool shouldSerializeidDest() => idDest != null;
  bool shouldSerializeindFinal() => indFinal != null;
  bool shouldSerializeindPres() => indPres != null;
}
