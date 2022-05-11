import 'package:app_condominios/model.dart';
import 'package:app_condominios/server.dart';
import 'package:app_condominios/utils.dart';
import 'package:app_condominios/extensions.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TelaReservas extends StatefulWidget {
  const TelaReservas({Key? key, required this.sessao, required this.espaco})
      : super(key: key);
  final Sessao sessao;
  final Espaco espaco;

  @override
  State<TelaReservas> createState() => _TelaReservasState();
}

class _TelaReservasState extends State<TelaReservas> {
  final hoje = today();
  final minData = today().subtract(const Duration(days: 30));
  final maxData = today().add(const Duration(days: 60));
  final List<Periodo> _periodos = Periodo.values;
  DateTime _dataFocada = today();
  DateTime? _dataSelecionada;
  List<Reserva>? _reservas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.espaco.nome ?? 'Reservas')),
        body: _buildBody(),
        backgroundColor: Colors.blue.shade100);
  }

  Widget _buildBody() {
    return Column(children: [
      _buildCardCalendario(),
      const Text('Reservas do dia:', style: TextStyle(fontSize: 16.0)),
      Expanded(
          child: _reservas != null ? _buildListView() : _buildMsgSemReservas())
    ]);
  }

  Widget _buildMsgSemReservas() {
    if (_dataSelecionada != null && _reservas == null) {
      return buildWidgetAguarde();
    }
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 60.0, color: Colors.blue.shade400),
          const SizedBox(height: 10.0),
          Text('Selecione uma data \npara ver as reservas.',
              style: TextStyle(fontSize: 20.0))
        ]);
  }

  ListView _buildListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _periodos.length,
        itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index) {
    final periodo = _periodos[index];
    final reserva = _reservas!.firstWhereOnNull((r) => r.periodo == periodo);
    return Card(
        child: ListTile(
            onTap: reserva == null && _dataSelecionada!.isAfterOrEquals(hoje)
                ? () => _onTapItem(periodo)
                : null,
            leading: _buildDeleteIcon(reserva),
            title: Text(periodoToStr(periodo) ?? '?',
                style: const TextStyle(fontSize: 16.0)),
            subtitle: Text(periodoToStrHora(periodo) ?? '?',
                style: TextStyle(fontSize: 13.0, color: Colors.grey.shade500)),
            trailing: reserva == null
                ? _buildTrailingSemReserva()
                : Text(reserva.morador?.nome ?? '?',
                    style: TextStyle(
                        color: Colors.grey.shade700, fontSize: 16.0))));
  }

  Widget? _buildDeleteIcon(Reserva? reserva) {
    if (reserva == null ||
        reserva.morador?.id != widget.sessao.usuario?.morador?.id) {
      return null;
    }
    return IconButton(
        onPressed: _onRemoverReserva,
        icon: Icon(Icons.delete_outline, color: Colors.grey.shade500));
  }



  Widget _buildTrailingSemReserva() {
    if (_dataSelecionada!.isBefore(hoje)) {
      return Text('Sem Reserva.',
          style: TextStyle(color: Colors.grey.shade500));
    }
    return const Chip(
        backgroundColor: Colors.green,
        visualDensity: VisualDensity.compact,
        label: Text('Reservar!',
            style: TextStyle(color: Colors.white, fontSize: 16.0)));
  }

  Card _buildCardCalendario() {
    return Card(
        margin: const EdgeInsets.all(12.0),
        elevation: 3.0,
        child: TableCalendar(
            locale: 'pt_BR',
            rangeSelectionMode: RangeSelectionMode.disabled,
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Mensal'},
            firstDay: minData,
            lastDay: maxData,
            focusedDay: _dataFocada,
            calendarStyle: CalendarStyle(
                weekendTextStyle: TextStyle(color: Colors.blue.shade600)),
            selectedDayPredicate: (day) => isSameDay(_dataSelecionada, day),
            onDaySelected: _onDaySelected));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_dataSelecionada, selectedDay)) {
      final data = onlyDate(selectedDay);
      setState(() {
        _dataSelecionada = data;
        _dataFocada = data;
        _reservas = null;
      });
      _carregarReservas();
    }
  }

  void _carregarReservas() {
    _fetchReservas().then((value) {
      setState(() {
        _reservas = value;
      });
    }, onError: (ex) {
      showMsg(
          ctx: context,
          titulo: 'Não foi possivel consultar',
          mensagem: ex.toString());
    });
  }

  Future<List<Reserva>> _fetchReservas() async {
    return await srvGetReservas(
        full: true,
        dataIni: _dataSelecionada,
        dataFim: _dataSelecionada,
        espacoId: widget.espaco.id,
        token: widget.sessao.token);
  }

  void _onTapItem(Periodo periodo) {
    final sessao = widget.sessao;
    if (sessao.usuario == null || sessao.usuario!.morador == null) {
      showMsg(
          ctx: context,
          titulo: 'Morador Necesário',
          mensagem: 'Falta os dados do morador na sessão de usuario');
      return;
    }
    Reserva reserva = Reserva(
        data: _dataSelecionada,
        espaco: widget.espaco,
        periodo: periodo,
        morador: sessao.usuario!.morador!);

    srvPostReserva(reserva, sessao.token).then((value) {
      _mostrarSnackBarReservaPostada();
      setState(() {
        _reservas = null;
        _carregarReservas();
      });
    }, onError: (ex) {
      showMsg(
          ctx: context,
          titulo: 'Não foi posivel postar a reserva',
          mensagem: ex.toString());
    });
  }

  void _mostrarSnackBarReservaPostada() {
    const data = 'Reserva postada com sucesso!';
    var ctx = context;
    showSnackBar(ctx: ctx, data: data);
  }
  void _onRemoverReserva(){

  }
}
