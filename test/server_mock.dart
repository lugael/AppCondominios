import 'fakes.dart';
import 'package:app_condominios/server.dart';
import 'package:app_condominios/model.dart';
import 'package:flutter/material.dart';


class ServerMock extends Server {
  Sessao? _sessao;
  @override
  Future<List<Morador>> srvGetMoradores({String? condominioId,
    String? nome,
    String? token,
    bool full = false}) async {
    final lista = fakeMoradores();
    if (nome != null) {
      return lista.where((m) => m.nome?.contains(nome) == true).toList();
    }
    return lista;
  }

  @override
  Future<List<Boleto>> srvGetBoletos({required String condominioId,
    String? moradorId,
    SituacaoBoleto? situacao,
    String? token,
    bool full = false}) async {
    return [];
  }

  @override
  Future<List<Espaco>> srvGetEspacos({required String condominioId,
    String? nome,
    String? token,
    TipoEspaco? tipo,
    bool full = false}) async {
    return [];
  }

  @override
  Future<List<Reserva>> srvGetReservas({String? moradorId,
    String? espacoId,
    DateTime? dataIni,
    DateTime? dataFim,
    String? token,
    bool full = false}) async {
    return [];
  }

//Post--------------------------------------------------------------------------
  @override
  Future<Sessao> srvPostLogin(String nomeUsuario, String senha) async {
    const token = "TKN-1234567897986546";
    _sessao = Sessao(
        token: token, usuario: Usuario(
        nomeUsuario: nomeUsuario, senha: senha, morador: Morador()));
    return _sessao!;
  }

  @override
  Future<void> srvPostLogoff({String? token}) async {
    _sessao = null;
  }

  @override
  Future<Reserva> srvPostReserva(Reserva reserva, String? token) async {
    return reserva;
  }
  @override
  Future<void> srvDeleteReserva({required String reservaId, String? token}) async {}

@override
ImageProvider buildImage({required String url, String? token}) {
  final newUrl = url.split('/');
  return AssetImage('assets/${newUrl.last}');
}}
