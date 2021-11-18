import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'models/account.dart';

void main() => runApp(const MyApp());

// フッターのボタンを返す(常に「前の画面に戻ることができない遷移」を行う)
List<Widget> fotterCommonButtons(BuildContext context) {
  String? current = ModalRoute.of(context)?.settings.name;
  return [
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/account_new'),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Account>> (
        future: DatabaseHelper().getAccounts(),
        builder: (context, snapshot) {
          List<Account>? accounts = snapshot.data;
          return !snapshot.hasData || accounts == null || accounts.isEmpty
            ? const Center(
              child: Text('口座が登録されていません')
            )
            : ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                accounts[index].id.toString() + ' : ' + accounts[index].name,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.lightBlueAccent
                                ),
                              ),
                              Text(
                                '初期資産額 : ' + NumberFormat("#,###").format(accounts[index].initRecord) + '円',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFF167F67)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF167F67),
                            ),
                            // 編集画面に遷移
                            onPressed: null,
                            // onPressed: () => Navigator.of(context).pushNamed('/account_edit'),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Color(0xFF167F67)
                            ),
                            onPressed: () => {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('口座削除'),
                                  content: Text('口座一覧から「' + accounts[index].id.toString() + ' : ' + accounts[index].name + '」を削除します'),
                                  actions: [
                                    TextButton(
                                      child: const Text("キャンセル"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () => {
                                        DatabaseHelper().deleteAccount(accounts[index]),
                                        Navigator.of(context).pushReplacementNamed('/account')
                                      },
                                    ),
                                  ],
                                )
                              )
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                );
              },
            );
        },
      )
    );
  }
}


class AccountNewPage extends StatelessWidget {
  AccountNewPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final initRecordController = TextEditingController();

  Future addRecord() async {
    var account = Account.fromMap({
      'id': 1,
      'name': nameController.text,
      'init_record': int.parse(initRecordController.text)
    });
    await DatabaseHelper().insertAccount(account);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('口座登録'),
      ),
      persistentFooterButtons: fotterCommonButtons(context),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "口座名",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '口座名を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: initRecordController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "初期資産額",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '初期資産額を入力してください';
                  }
                  return null;
                },
              ),
              const Divider(),
              ElevatedButton(
                child: const Text('登録'),
                onPressed: () => {
                  if (_formKey.currentState!.validate()) {
                    // 入力データが正常な場合の処理
                    addRecord(),
                    Navigator.of(context).pushReplacementNamed('/account')
                  }
                },
              )
            ],
          ),
        )
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