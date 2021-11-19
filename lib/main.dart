import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/account_new_page.dart';
import 'package:flutter_application_1/pages/account_page.dart';
import 'package:flutter_application_1/pages/list_page.dart';
import 'package:flutter_application_1/pages/main_page.dart';
import 'package:flutter_application_1/pages/setting_page.dart';

void main() => runApp(const MyApp());

// フッターのボタンを返す(常に「前の画面に戻ることができない遷移」を行う)
List<Widget> fotterCommonButtons(BuildContext context) {
  String? current = ModalRoute.of(context)?.settings.name;
  return [
    TextButton(
      onPressed: (current == '/main') ? null : () => Navigator.of(context).pushReplacementNamed('/main'),
      child: Column(
        children: const <Widget>[
          Icon(Icons.home),
          Flexible(child: Text('ホーム'))
        ],
      ),
    ),
    TextButton(
      onPressed: (current == '/list') ? null : () => Navigator.of(context).pushReplacementNamed('/list'),
      child: Column(
        children: const <Widget>[
          Icon(Icons.list),
          Flexible(child: Text('リスト'))
        ],
      ),
    ),
    TextButton(
      onPressed: (current == '/account' || current == '/account_new') ? null : () => Navigator.of(context).pushReplacementNamed('/account'),
      child: Column(
        children: const <Widget>[
          Icon(Icons.account_balance),
          Flexible(child: Text('口座'))
        ],
      ),
    ),
    TextButton(
      onPressed: (current == '/setting') ? null : () => Navigator.of(context).pushReplacementNamed('/setting'),
      child: Column(
        children: const <Widget>[
          Icon(Icons.settings),
          Flexible(child: Text('設定'))
        ],
      ),
    ),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: const MainPage(),
      initialRoute: '/main',
      routes: <String, WidgetBuilder> {
        '/main': (BuildContext context) => const MainPage(),
        '/list': (BuildContext context) => ListPage(),
        '/account': (BuildContext context) => const AccountPage(),
        '/account_new': (BuildContext context) => AccountNewPage(),
        '/setting': (BuildContext context) => const SettingPage()
      }
    );
  }
}
