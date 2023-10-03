import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({super.key, required this.controller, required this.selectedCategory});

  final TextEditingController _searchController = TextEditingController();
  final StreamController<QuerySnapshot> controller;
  final String selectedCategory;

  Future<void> _searchOffers() async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("offers");

    if(selectedCategory.isNotEmpty){
      query = query
          .where("category", isEqualTo: selectedCategory)
          .where("titleToLowerCase", isGreaterThanOrEqualTo: _searchController.text.toLowerCase())
          .where("titleToLowerCase", isLessThan: _searchController.text.toLowerCase() + 'z');
    }else{
      query = query
          .where("titleToLowerCase", isGreaterThanOrEqualTo: _searchController.text.toLowerCase())
          .where("titleToLowerCase", isLessThan: _searchController.text.toLowerCase() + 'z');
    }


    Stream<QuerySnapshot> stream = query.snapshots();

    stream.listen((data) {
      controller.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Qual serviço você procura?',
      ),
      onChanged: (query){
        _searchOffers();
      },
    );
  }
}
