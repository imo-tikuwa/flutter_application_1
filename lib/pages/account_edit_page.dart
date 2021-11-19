import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/arguments/account_edit_arguments.dart';
import 'package:flutter_application_1/database_helper.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/account.dart';

class AccountEditPage extends StatelessWidget {
  AccountEditPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final initRecordController = TextEditingController();

  Future updateRecord() async {
    var account = Account.fromMap({
      'id': int.parse(idController.text),
      'name': nameController.text,
      'init_record': int.parse(initRecordController.text)
    });
    await DatabaseHelper().updateAccount(account);
  }

  @override
  Widget build(BuildContext context) {

    Object? args = ModalRoute.of(context)!.settings.arguments;
    late Account account;
    if (args is AccountEditarguments) {
      account = args.account;
      idController.text = account.id.toString();
      nameController.text = account.name;
      initRecordController.text = account.initRecord.toString();
    } else {
      // エラー？
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('口座更新'),
      ),
      persistentFooterButtons: fotterCommonButtons(context),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: false,
                child: TextFormField(
                  controller: idController,
                ),
              ),
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
                child: const Text('更新'),
                onPressed: () => {
                  if (_formKey.currentState!.validate()) {
                    updateRecord(),
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