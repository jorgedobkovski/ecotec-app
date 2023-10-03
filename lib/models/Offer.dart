import 'package:cloud_firestore/cloud_firestore.dart';

class Offer{

  String _id = "";
  String _location= "";
  String _category= "";
  String _title= "";
  String _titleToLowerCase= "";
  String _price= "";
  String _description= "";
  String _userId = "";



  List<String> _pictures = List.empty(growable: true);

  Offer(){

  }

  Offer.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.location = documentSnapshot["location"];
    this.category = documentSnapshot["category"];
    this.title = documentSnapshot["title"];
    this.titleToLowerCase = documentSnapshot["titleToLowerCase"];
    this.price = documentSnapshot["price"];
    this.description = documentSnapshot["description"];
    this.userId = documentSnapshot["userId"];
    this.pictures = List<String>.from(documentSnapshot["pictures"]);
  }

  Offer.generateId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference offers = db.collection("my_offers");
    this.id = offers.doc().id;

    this.pictures = [];
  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "id": this.id,
      "location": this.location,
      "category": this.category,
      "title": this.title,
      "titleToLowerCase": this.titleToLowerCase,
      "price": this.price,
      "description": this.description,
      "userId": this.userId,
      "pictures": this.pictures
    };

    return map;

  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get location => _location;

  List<String> get pictures => _pictures;

  set pictures(List<String> value) {
    _pictures = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  set location(String value) {
    _location = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get titleToLowerCase => _titleToLowerCase;

  set titleToLowerCase(String value) {
    _titleToLowerCase = value;
  }
}