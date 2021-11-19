import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_helper.dart';
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
          children: <Widget>[
            ElevatedButton(
              child: const Text('データベース初期化'),
              onPressed: () => {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('データベース初期化'),
                    content: const Text('データベースを初期化すると、これまでに入力した口座情報が失われます。'),
                    actions: [
                      TextButton(
                        child: const Text("キャンセル"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () => {
                          DatabaseHelper().dropAccount(),
                          Navigator.of(context).pushReplacementNamed('/setting')
                        },
                      ),
                    ],
                  )
                )
              },
            )
          ],
        ),
      )
    );
  }
}