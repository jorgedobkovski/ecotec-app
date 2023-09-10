import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotec/views/widgets/OfferWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/Offer.dart';
import 'package:flutter/material.dart';

class MyOffers extends StatefulWidget {
  const MyOffers({super.key});

  @override
  State<MyOffers> createState() => _MyOffersState();
}

class _MyOffersState extends State<MyOffers> {

  late String _currentUserId;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _restoreCurrentUserData() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User currentUser = auth.currentUser!;
    _currentUserId = currentUser.uid;
  }

  Future<Stream<QuerySnapshot>> _listenerOffers() async{
    await _restoreCurrentUserData();
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
      .collection("my_offers")
      .doc(_currentUserId)
      .collection("offers")
      .snapshots();

    stream.listen((data) {
      _controller.add(data);
    });

    return stream;
  }

  _removeOffer(String offerId){
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("my_offers")
      .doc(_currentUserId)
      .collection("offers")
      .doc(offerId)
      .delete().then((_){
        db.collection("offers")
          .doc(offerId)
          .delete();
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listenerOffers();
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

                    return OfferWidget(
                      offer: offer,
                      onPressedRemover: (){
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                  title: Text("Confirmar"),
                                  content: Text("Deseja realmente excluir o anúncio?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancelar",
                                      style: TextStyle(
                                          color: Colors.black
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: (){
                                          _removeOffer(offer.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Remover",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                      ),
                                    ),
                                  ]
                              );
                            }
                        );
                      },
                    );
                  }
              );
          }
          return Container();
        },
      ),
    );
  }
}
