import 'package:app_condominios/model.dart';
import 'package:app_condominios/server.dart';
import 'package:app_condominios/utils.dart';
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
  final minData = today().subtract(const Duration(days: 30));
  final maxData = today().add(const Duration(days: 60));
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
          child: (_reservas?.isNotEmpty) == true
              ? _buildListView()
              : _buildMsgSemReservas())
    ]);
  }

  Widget _buildMsgSemReservas() {
    if(_dataSelecionada!= null && _reservas == null){
      return buildWidgetAguarde();
    }
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 60.0, color: Colors.blue.shade400),
          const SizedBox(height: 10.0),
          Text(_dataSelecionada == null
              ? 'Selecione uma data \npara ver as reservas.'
              : 'Não há reservas para \n o dia ${ddMMyyyy.format(_dataSelecionada!)}.')
        ]);
  }

  ListView _buildListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _reservas!.length,
        itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index) {
    final reserva = _reservas![index];
    final periodo = reserva.periodo;
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        Text(reserva.morador?.nome ?? '?'),
        const Spacer(),
        Text('${periodoToStr(periodo)} (${periodoToStrHora(periodo)})',
            style: TextStyle(color: Colors.grey.shade700))
      ]),
    ));
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
      setState(() {
        _dataSelecionada = selectedDay;
        _dataFocada = selectedDay;
        _reservas = null;
      });
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
  }

  Future<List<Reserva>> _fetchReservas() async {
    await Future.delayed(const Duration(seconds: 1));
    return await srvGetReservas(
        full: true,
        dataIni: _dataSelecionada,
        dataFim: _dataSelecionada,
        espacoId: widget.espaco.id,
        token: widget.sessao.token);
  }
}
