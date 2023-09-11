import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotec/main.dart';
import 'package:flutter/material.dart';

import '../models/Category.dart';

class Config{
  static List<DropdownMenuItem<String>> getCategories(){

    List<DropdownMenuItem<String>> dropdownItems = [];

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("categories")
        .snapshots();

    dropdownItems.add(
      DropdownMenuItem(child: Text(
        "Categoria", style: TextStyle(
        color: ecotecTheme.colorScheme.primary,
      ),
      ), value: null,
      ),
    );

    stream.listen((data) {
      List<DocumentSnapshot> categories = data.docs;
      for(int i = 0; i < categories.length; i++ ){
        DocumentSnapshot documentSnapshot = categories[i];
        Category category = Category.fromDocumentSnapshot(documentSnapshot);
        dropdownItems.add(
            DropdownMenuItem(child: Text(category.name), value: category.id,)
        );
      }
    });

    return dropdownItems;
  }

  static List<DropdownMenuItem<String>> getLocations(){
    List<DropdownMenuItem<String>> dropdownItems = [];

    dropdownItems.add(
      DropdownMenuItem(child: Text(
        "Localização", style: TextStyle(
        color: ecotecTheme.colorScheme.primary,
      ),
      ), value: null,
      ),
    );

    for(var location in Estados.listaEstadosSigla){
      dropdownItems.add(
        DropdownMenuItem(child: Text(location), value: location,)
      );
    }

    return dropdownItems;
  }

}