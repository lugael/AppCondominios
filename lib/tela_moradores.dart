import 'package:app_condominios/fakes.dart';
import 'package:app_condominios/model.dart';
import 'package:flutter/material.dart';

class TelaMoradores extends StatefulWidget {
  const TelaMoradores({Key? key}) : super(key: key);

  @override
  State<TelaMoradores> createState() => _TelaMoradoresState();
}

class _TelaMoradoresState extends State<TelaMoradores> {
  final List<Morador> _moradores = fakeMoradores();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text('Moradores'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
    );
  }
}