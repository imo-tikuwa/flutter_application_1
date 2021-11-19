import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      persistentFooterButtons: fotterCommonButtons(context),
      body: Center(
        child: Column(
          children: const <Widget>[
            Text('ここ設定画面'),
            Text('ここ設定画面')
          ],
        ),
      )
    );
  }
}