import 'dart:convert';
import 'dart:io';
import 'package:app_condominios/utils.dart';
import 'package:app_condominios/model.dart';
import 'package:http/http.dart' as http;

const urlSrv = "tars1.ddns.net:8445";
const statusOk = 200;
const statusBadResquest = 400;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final httpClient = super.createHttpClient(context);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return cert.issuer.contains('Deschamps');
    };
    return httpClient;
  }
}

Future<String> _serverGET(
    {required String endpoint,
    Map<String, dynamic>? params,
    String? token}) async {
  params?.removeWhere((key, value) => value == null);

  final url = Uri.https(urlSrv, endpoint, params);
  final headers = token != null ? {'token': token} : null;

  final response = await http.get(url, headers: headers);
  final responseBody = utf8.decode(response.bodyBytes);

  if (response.statusCode != statusOk) {
    throw responseBody;
    // final Map<String, dynamic> map = json.decode(responseBody);
    // throw map.containsKey('message') ? map['message'] : '';
  }
  return responseBody;
}

Future<String> _serverPOST(
    {required String endpoint, required String body, String? token}) async {
  final url = Uri.https(urlSrv, endpoint);
  final headers = {'Content-Type': 'application/json'};
  if (token != null) {
    headers['token'] = token;
  }

  final response = await http.post(url,
      headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));

  if (response.statusCode != statusOk) {
    throw response.body;
  }
  return response.body;
}

Future<String> _serverDelete(
    {required String endpoint, required String id, String? token}) async {
  final url = Uri.https(urlSrv, '$endpoint/$id');
  final headers = token != null ? {'token': token} : null;

  final response = await http.delete(url, headers: headers);
  final responseBody = utf8.decode(response.bodyBytes);

  if (response.statusCode != statusOk) {
    throw responseBody;
    // final Map<String, dynamic> map = json.decode(responseBody);
    // throw map.containsKey('message') ? map['message'] : '';
  }
  return responseBody;
}

Future<List<Morador>> srvGetMoradores(
    {String? condominioId,
    String? nome,
    String? token,
    bool full = false}) async {
  String response = await _serverGET(
      endpoint: 'moradores',
      params: {
        'condominioId': condominioId,
        'nome': nome,
        'full': full.toString()
      },
      token: token);
  Iterable list = json.decode(response);

  return list.map((m) => Morador.fromMap(m)).toList();
}

Future<List<Boleto>> srvGetBoletos(
    {required String condominioId,
    String? moradorId,
    SituacaoBoleto? situacao,
    String? token,
    bool full = false}) async {
  String response = await _serverGET(
      endpoint: 'boletos',
      params: {
        'condominioId': condominioId,
        'moradorId': moradorId,
        'situacao':
            situacao == null ? null : situacaoBoletoToId(situacao)?.toString(),
        'full': full.toString()
      },
      token: token);
  Iterable list = json.decode(response);
  return list.map((m) => Boleto.fromMap(m)).toList();
}

Future<List<Espaco>> srvGetEspacos(
    {required String condominioId,
    String? nome,
    String? token,
    TipoEspaco? tipo,
    bool full = false}) async {
  String response = await _serverGET(
      endpoint: 'espacos',
      params: {
        'condominioId': condominioId,
        'nome': nome,
        'tipo': tipoEspacoToId(tipo),
        'full': full.toString()
      },
      token: token);
  Iterable list = json.decode(response);
  return list.map((m) => Espaco.fromMap(m)).toList();
}

Future<List<Reserva>> srvGetReservas(
    {String? moradorId,
    String? espacoId,
    DateTime? dataIni,
    DateTime? dataFim,
    String? token,
    bool full = false}) async {
  String response = await _serverGET(
      endpoint: 'reservas',
      params: {
        'moradorId': moradorId,
        'espacoId': espacoId,
        'dataIni': dataIni == null ? null : yyyyMMdd.format(dataIni),
        'dataFim': dataFim == null ? null : yyyyMMdd.format(dataFim),
        'full': full.toString()
      },
      token: token);
  Iterable list = json.decode(response);
  return list.map((m) => Reserva.fromMap(m)).toList();
}

//Post--------------------------------------------------------------------------
Future<Sessao> srvPostLogin(String nomeUsuario, String senha) async {
  final strObjLogin =
      json.encode({'nomeUsuario': nomeUsuario, 'senha': toMd5(senha)});
  String response = await _serverPOST(endpoint: 'login', body: strObjLogin);

  Map<String, dynamic> mapSessao = json.decode(response);
  return Sessao.fromMap(mapSessao);
}

Future<Reserva> srvPostReserva(Reserva reserva, String? token) async {
  final body = json.encode(reserva.toMap());
  String response =
      await _serverPOST(endpoint: 'reservas', body: body, token: token);

  return Reserva.fromMap(json.decode(response));
}

Future<void> srvDeleteReserva(
    {required String reservaId, String? token}) async {
  await _serverDelete(endpoint: 'reservas', token: token, id: reservaId);
}
