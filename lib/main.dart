import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// フッターのボタンを返す(常に「前の画面に戻ることができない遷移」を行う)
List<Widget> fotterCommonButtons(BuildContext context) {
  String? current = ModalRoute.of(context)?.settings.name;
  List<Widget> buttons = [
    TextButton(
      onPressed: (current == '/main' || current == '/') ? null : () => Navigator.of(context).pushReplacementNamed('/main'),
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
      onPressed: (current == '/account') ? null : () => Navigator.of(context).pushReplacementNamed('/account'),
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
  return buttons;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: const MainPage(),
      routes: <String, WidgetBuilder> {
        '/main': (BuildContext context) => const MainPage(),
        '/list': (BuildContext context) => ListPage(),
        '/account': (BuildContext context) => const AccountPage(),
        '/setting': (BuildContext context) => const SettingPage()
      }
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      persistentFooterButtons: fotterCommonButtons(context),
      body: const Center(
        child: Text('Main Page'),
      )
    );
  }
}

class ListPage extends StatelessWidget {
  ListPage({Key? key}) : super(key: key);

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
      ),
      persistentFooterButtons: fotterCommonButtons(context),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider(
              color: Colors.blue
            );
          }
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return ListTile(
            title: Text(
              index.toString() + ' ' + _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
          );
        }
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('口座一覧'),
      ),
      persistentFooterButtons: fotterCommonButtons(context),
      body: const Center(
        child: Text('ここに登録済みの口座を一覧表示する'),
      )
    );
  }
}

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