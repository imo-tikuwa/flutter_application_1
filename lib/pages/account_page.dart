import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/arguments/account_edit_arguments.dart';
import 'package:flutter_application_1/database_helper.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/account.dart';
import 'package:intl/intl.dart';

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
                            onPressed: () => Navigator.of(context).pushNamed('/account_edit', arguments: AccountEditarguments(accounts[index])),
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