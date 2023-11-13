import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotec/models/Category.dart';
import 'package:flutter/material.dart';

import '../../models/Offer.dart';

class MainFilterWidget extends StatefulWidget {
  MainFilterWidget({super.key, required this.controller, required this.callback});

  final StreamController<QuerySnapshot> controller;
  final Function callback;

  @override
  State<MainFilterWidget> createState() => _MainFilterWidgetState();
}

class _MainFilterWidgetState extends State<MainFilterWidget> {

  final _categoryController = StreamController<QuerySnapshot>.broadcast();
  String _selectedCategory = "";

  get controller => widget.controller;
  get callback => widget.callback;

  String getSelectedCategory() {
    return _selectedCategory;
  }

  Future<void> _filterOffers() async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection("offers");

    if(_selectedCategory.isNotEmpty){
      query = query.where("category", isEqualTo: _selectedCategory);
    }

    Stream<QuerySnapshot> stream = query.snapshots();

    stream.listen((data) {
      controller.add(data);
    });
  }

  Future<Stream<QuerySnapshot>> _listenerCategories()async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
      .collection("categories")
      .snapshots();

    stream.listen((data) {
      _categoryController.add(data);
    });

    return stream;
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listenerCategories();
  }

  @override
  Widget build(BuildContext context) {

    var loadingData = Center(
      child: Column(children: <Widget>[
        CircularProgressIndicator()
      ],),
    );

    return StreamBuilder(
        stream: _categoryController.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return loadingData;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError)
                return Text("Erro ao recuperar os dados!");

              QuerySnapshot querySnapshot = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, index) {
                    List<DocumentSnapshot> categories = querySnapshot.docs
                        .toList();
                    DocumentSnapshot documentSnapshot = categories[index];
                    Category category = Category.fromDocumentSnapshot(
                        documentSnapshot);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if(_selectedCategory != category.id){
                            _selectedCategory = category.id;
                            callback(category.id);
                          } else{
                            _selectedCategory = "";
                            callback("");
                          }
                          _filterOffers();
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, bottom: 15 ),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F0F5),
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: _selectedCategory == category.id ? Colors.green : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Icon(
                                      IconData(
                                        int.parse(category.icon),
                                        fontFamily: 'MaterialIcons',
                                      ),
                                      color: _selectedCategory == category.id ? Colors.green : Colors.black45,
                                      size: 40,
                                    ),
                                  ),
                                  Text(category.name,
                                    style: TextStyle(
                                      color: _selectedCategory == category.id ? Colors.green : Colors.black45,
                                      fontWeight: _selectedCategory == category.id ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      )
                      );
                  }

              );
          }
        }
    );
  }
}
