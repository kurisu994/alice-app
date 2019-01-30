class AccountModel {
  int id;
  String account;
  String cipherCode;
  int accountType;
  String remark;

  AccountModel(
      this.id, this.account, this.cipherCode, this.accountType, this.remark);

  AccountModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        account = json['account'],
        cipherCode = json['cipherCode'],
        accountType = json['accountType'],
        remark = json['remark'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'account': account,
        'cipherCode': cipherCode,
        'accountType': accountType,
        'remark': remark,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"id\":\"$id\"");
    sb.write(",\"account\":\"$account\"");
    sb.write(",\"cipherCode\":\"$cipherCode\"");
    sb.write(",\"accountType\":\"$accountType\"");
    sb.write(",\"remark\":\"$remark\"");
    sb.write('}');
    return sb.toString();
  }
}
