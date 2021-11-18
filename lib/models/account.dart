class Account {
  late int id;
  late String name;
  late int initRecord;

  Account(this.id, this.name, this.initRecord);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'init_record': initRecord,
    };
  }

  Account.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    initRecord = map['init_record'];
  }

  void setAccountId(int id) {
    this.id = id;
  }
}
