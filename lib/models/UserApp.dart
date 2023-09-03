class UserApp{
  late String _idUser;
  late String _name;
  late String _email;
  late String _password;
  late String _phone;

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  Usuario({
    required String idUser,
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    _idUser = idUser;
    _name = name;
    _email = email;
    _password = password;
    _phone = phone;
  }

  Map<String, dynamic> toMap(){

    Map<String,dynamic> map = {
      "idUsuario" : this.idUser,
      "nome"      : this.name,
      "email"     : this.email,
      "telefone"  : this.phone
    };

    return map;

  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }
}