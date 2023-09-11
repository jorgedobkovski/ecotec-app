import 'package:cloud_firestore/cloud_firestore.dart';

class Category{

  String _id = "";
  String _name = "";
  String _description = "";
  String _icon = "";

  Category(){

  }

  Category.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.description = documentSnapshot["description"];
    this.name = documentSnapshot["name"];
    this.icon = documentSnapshot["icon"];
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get icon => _icon;

  set icon(String value) {
    _icon = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }
}