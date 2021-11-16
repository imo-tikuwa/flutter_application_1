import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: const MainPage(),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => const MainPage(),
        '/list': (BuildContext context) => ListPage(),
        '/another': (BuildContext context) => const AnotherPage()
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
      body: const Center(
        child: Text('Main Page'),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed('/list'),
          child: const Text('List Page')
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed('/another'),
          child: const Text('Another Page')
        ),
      ]
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

class AnotherPage extends StatelessWidget {
  const AnotherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Another Page'),
      ),
      body: const Center(
        child: Text('Another Page'),
      )
    );
  }
}