import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotec/models/Category.dart';
import 'package:flutter/material.dart';

class MainFilterWidget extends StatefulWidget {
  const MainFilterWidget({super.key});

  @override
  State<MainFilterWidget> createState() => _MainFilterWidgetState();
}

class _MainFilterWidgetState extends State<MainFilterWidget> {

  final _categoryController = StreamController<QuerySnapshot>.broadcast();


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
                      onTap: () {},
                      child: Container(
                        width: 100,
                        child: Card(
                          child: Text(
                              category.name
                          ),
                        ),
                      ),
                    );
                  }
              );
          }
        }
    );
  }
}