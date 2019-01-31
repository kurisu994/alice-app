class AccountModel {
  int id;
  String account;
  String name;
  String cipherCode;
  int accountType;
  String remark;
  String extra;

  AccountModel(this.id, this.account, this.cipherCode, this.accountType,
      this.remark,
      this.name, this.extra);

  AccountModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        account = json['account'],
        name = json['name'],
        cipherCode = json['cipherCode'],
        accountType = json['accountType'],
        remark = json['remark'],
        extra = json['extra'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'account': account,
    'name': name,
        'cipherCode': cipherCode,
        'accountType': accountType,
        'remark': remark,
    'extra': extra,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"id\":\"$id\"");
    sb.write(",\"account\":\"$account\"");
    sb.write(",\"name\":\"$name\"");
    sb.write(",\"cipherCode\":\"$cipherCode\"");
    sb.write(",\"accountType\":\"$accountType\"");
    sb.write(",\"remark\":\"$remark\"");
    sb.write(",\"extra\":\"$extra\"");
    sb.write('}');
    return sb.toString();
  }
}
