import 'package:cloud_firestore/cloud_firestore.dart';

class UserApp{
  late String _idUser;
  late String _name;
  late String _email;
  late String _password;
  late String _phone;
  late String _profilePhotoUrl;

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
    required String profilePhotoUrl
  }) {
    _idUser = idUser;
    _name = name;
    _email = email;
    _password = password;
    _phone = phone;
    _profilePhotoUrl = profilePhotoUrl;
  }

  UserApp(){

  }

  UserApp.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.idUser = documentSnapshot.id;
    this.name = documentSnapshot["nome"];
    this.email = documentSnapshot["email"];
    this.phone = documentSnapshot["telefone"];
    this.profilePhotoUrl = documentSnapshot["profilePhotoUrl"];
  }

  Map<String, dynamic> toMap(){

    Map<String,dynamic> map = {
      "idUsuario" : this.idUser,
      "nome"      : this.name,
      "email"     : this.email,
      "telefone"  : this.phone,
      "profilePhotoUrl": this.profilePhotoUrl,
    };

    return map;

  }

  Future<UserApp?> getUserById(String userId) async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userDoc = await usersCollection.doc(userId).get();

      if (userDoc.exists) {
        return UserApp.fromDocumentSnapshot(userDoc);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar usuário por ID: $e');
      return null;
    }
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

  String get profilePhotoUrl => _profilePhotoUrl;

  set profilePhotoUrl(String value) {
    _profilePhotoUrl = value;
  }
}