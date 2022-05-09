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
    throw response.body;
    // final Map<String, dynamic> map = json.decode(responseBody);
    // throw map.containsKey('message') ? map['message'] : '';
  }
  return responseBody;
}

Future<String> _serverPOST({required String endpoint,required String body, String? token}) async {

  final url = Uri.https(urlSrv, endpoint);
  final headers = {'Content-Type':'application/json'};
  if(token != null){
    headers['token'] = token;
  }

  final response = await http.post(url, headers: headers, body: body, encoding: Encoding.getByName("UTF-8"));

  if (response.statusCode != statusOk) {
    throw response.body;
    // final Map<String, dynamic> map = json.decode(response.body);
    // throw map.containsKey('message') ? map['message'] : '';
  }
  return response.body;
}

Future<List<Morador>> srvGetMoradores(
    {String? condominioId, String? nome, bool? full }) async {
  String response = await _serverGET(
      endpoint: 'moradores',
      params: {'condominioId': condominioId, 'nome': nome, 'full': full?.toString()});
  Iterable list = json.decode(response);
  return list.map((m) => Morador.fromMap(m)).toList();
}


Future<Sessao> srvPostLogin(String nomeUsuario, String senha) async{
  final strObjLogin =  json.encode({'nomeUsuario': nomeUsuario,'senha': toMd5(senha)});
  String response = await _serverPOST(endpoint: 'login', body: strObjLogin);

  Map<String, dynamic> mapSessao = json.decode(response);
  return Sessao.fromMap(mapSessao);
}
