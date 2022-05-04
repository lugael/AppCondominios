import 'package:flutter/material.dart';

class TelaMoradores extends StatefulWidget {
  const TelaMoradores({Key? key}) : super(key: key);

  @override
  State<TelaMoradores> createState() => _TelaMoradoresState();
}

class _TelaMoradoresState extends State<TelaMoradores> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text('Home'),
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