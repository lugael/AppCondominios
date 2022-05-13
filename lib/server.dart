import 'package:app_condominios/model.dart';
import 'package:flutter/cupertino.dart';

const statusOk = 200;
const statusBadResquest = 400;

abstract class Server {
  Future<List<Morador>> srvGetMoradores(
      {String? condominioId, String? nome, String? token, bool full = false});

  Future<List<Boleto>> srvGetBoletos(
      {required String condominioId,
      String? moradorId,
      SituacaoBoleto? situacao,
      String? token,
      bool full = false});

  Future<List<Espaco>> srvGetEspacos(
      {required String condominioId,
      String? nome,
      String? token,
      TipoEspaco? tipo,
      bool full = false});

  Future<List<Reserva>> srvGetReservas(
      {String? moradorId,
      String? espacoId,
      DateTime? dataIni,
      DateTime? dataFim,
      String? token,
      bool full = false});

//Post--------------------------------------------------------------------------
  Future<Sessao> srvPostLogin(String nomeUsuario, String senha);

  Future<void> srvPostLogoff({String? token});

  Future<Reserva> srvPostReserva(Reserva reserva, String? token);

  Future<void> srvDeleteReserva({required String reservaId, String? token});

  ImageProvider buildImage({required String url, String? token});
}
