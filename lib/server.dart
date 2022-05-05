import 'dart:convert';
import 'dart:io';
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

Future<List<Morador>> srvGetMoradores(
    {String? condominioId, String? nome, bool? full }) async {
  final response = await serverGET(
      endpoint: 'moradores',
      params: {'condominioId': condominioId, 'nome': nome, 'full': full});
  Iterable list = json.decode(response);
  return list.map((m) => Morador.fromMap(m)).toList();
}

Future<String> serverGET(
    {required String endpoint,
    Map<String, dynamic>? params,
    String? token}) async {
  params?.removeWhere((key, value) => value == null);

  final url = Uri.https(urlSrv, endpoint, params);
  final headers = token != null ? {'token': token} : null;

  final response = await http.get(url, headers: headers);
  final responseBody = utf8.decode(response.bodyBytes);

  if (response.statusCode != statusOk) {
    final Map<String, dynamic> map = json.decode(responseBody);
    throw map.containsKey('message') ? map['message'] : '';
  }
  return responseBody;
}
