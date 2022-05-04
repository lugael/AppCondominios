

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text('Home'),
      ),
      drawer: Drawer(

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logomarca.png'),
              const SizedBox(height: 20.0),
              Text(
                'Seja bem-vindo(a) ao app para controle de condomínios!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 20.0,
                fontWeight: FontWeight.bold)),
              const SizedBox(height: 20.0),
              Container(
                  width: 240,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12)
                  ),
                child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.00),
                      Icon(Icons.info_outline_rounded,size: 50, color: Colors.blueAccent),
                      Text('Acesse as funções do app pelo menu lateral.',
                      textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold
                      ))
                    ],
                  ),
                ),
              const SizedBox(height: 20.0),
              Text(
                'Powered by (Luis) @ Proway',
                style: TextStyle(
                  color: Colors.grey.shade400
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}