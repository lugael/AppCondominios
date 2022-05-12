import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TelaSobre extends StatefulWidget {
  const TelaSobre({Key? key}) : super(key: key);

  @override
  State<TelaSobre> createState() => _TelaSobreState();
}

class _TelaSobreState extends State<TelaSobre> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        _info = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre este app')),
      body: _buildBody(screenSize),
    );
  }

  Widget _buildBody(Size screenSize) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset('assets/logomarca.png', width: screenSize.width * 0.5),
      SizedBox(height: screenSize.height * 0.05),
      Text('O condominio na sua mão',
          style: TextStyle(
              fontSize: screenSize.height * 0.03, color: Colors.grey)),
      SizedBox(height: screenSize.height * 0.05),
      Text('Versão:', style: TextStyle(fontSize: screenSize.height * 0.02)),
      Text(_info?.version ?? 'Carregando..',
          style: TextStyle(fontSize: screenSize.height * 0.02)),
      SizedBox(height: screenSize.height * 0.05),
      Text('Build Nr:', style: TextStyle(fontSize: screenSize.height * 0.02)),
      Text(_info?.buildNumber ?? 'Carregando..',
          style: TextStyle(fontSize: screenSize.height * 0.02))
    ]));
  }
}
