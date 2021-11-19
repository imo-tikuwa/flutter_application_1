import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_helper.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/account.dart';

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