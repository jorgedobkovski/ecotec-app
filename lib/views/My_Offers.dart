import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/Offer.dart';

class MyOffers extends StatefulWidget {
  const MyOffers({super.key});

  @override
  State<MyOffers> createState() => _MyOffersState();
}

class _MyOffersState extends State<MyOffers> {

  late String _idCurrentUser;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _restoreCurrentUserData() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User currentUser = auth.currentUser!;
    _idCurrentUser = currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {

    var loadingData = Center(
      child: Column(children: <Widget>[
        Text("Carregando anúncios..."),
        CircularProgressIndicator()
      ],),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Meus anúncios"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.pushNamed(context, "/new-offer");
        },
        foregroundColor: Colors.white,
        label: Text("Adicionar"),
        icon: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return loadingData;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasError)
                return Text("Erro ao recuperar os dados!");

              QuerySnapshot querySnapshot = snapshot.data!;
              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, index){
                    List<DocumentSnapshot> offers = querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = offers[index];
                    Offer offer = Offer.fromDocumentSnapshot(documentSnapshot);

                    return 
                  }
              );
          }
        },
      ),
    );
  }
}
