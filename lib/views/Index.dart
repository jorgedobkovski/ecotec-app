import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotec/models/Offer.dart';
import 'package:ecotec/models/UserApp.dart';
import 'package:ecotec/views/widgets/CustomAppBar.dart';
import 'package:ecotec/views/widgets/CustomSearchBar.dart';
import 'package:ecotec/views/widgets/MainFilterWidget.dart';
import 'package:ecotec/views/widgets/OfferWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {

  List<String> _menuItems = [""];
  String _selectedCategoryIndex = "";
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String profilePic = "https://firebasestorage.googleapis.com/v0/b/ecotec-30a76.appspot.com/o/profile_pics%2FwzTa3zTkzVdm5L3Y5XsfnfNqKgA3%2Fnull.jpg?alt=media&token=3c9f7867-3073-44ca-8e0b-7bcfe62bebb5";

  _logoutUser() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamed(context, "/login");
  }

  void callbackDaAppBar(String variavel){
    setState((){_selectedCategoryIndex = variavel;});
  }

  Future _verifyUser() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if( currentUser == null ){
      _menuItems = ["Entrar/Cadastrar"];
    } else {
      _menuItems = ["Meus anúncios", "Deslogar"];
    }
  }

  _selectedMenuItem(String selectedItem){
    switch(selectedItem){
      case "Meus anúncios":
        Navigator.pushNamed(context, "/my-offers");
        break;
      case "Entrar/Cadastrar":
        Navigator.pushNamed(context, "/login");
        break;
      case "Deslogar":
        _logoutUser();
        break;
    }
  }

  Future<Stream<QuerySnapshot>> _listenerOffers() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection("offers").snapshots();

    stream.listen((data) {
      _controller.add(data);
    });

    return stream;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyUser();
    _listenerOffers();
  }

  @override
  Widget build(BuildContext context) {

    var actionsAppBar = <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 10),
        child: PopupMenuButton(
          icon: CircleAvatar(
            backgroundImage: NetworkImage(profilePic)
          ),
          onSelected: _selectedMenuItem,
          itemBuilder: (context){
            return _menuItems.map((String item){
              return PopupMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList();
          },
        ),
      )
    ];

    var loadingData = Center(
      child: Column(children: <Widget>[
        Text("Carregando anúncios..."),
        CircularProgressIndicator()
      ],),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        context: context,
        height: AppBar().preferredSize.height,
        searchBar: CustomSearchBar(
          controller: _controller,
          selectedCategory: _selectedCategoryIndex,
        ),
        actions: actionsAppBar,
      ),
      body: Container(
        child: Column(children: <Widget>[
          Column(children: <Widget>[
            Container(
              height: 100,
              child: MainFilterWidget(
                controller: _controller,
                callback: callbackDaAppBar,
              ),
            ),
          ],
          ),
          StreamBuilder(
            stream: _controller.stream,
            builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return loadingData;
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  QuerySnapshot querySnapshot = snapshot.data!;
                  if(querySnapshot.docs.length == 0){
                    return Container(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        "Nenhum anúncio! :(",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (_, index){
                          List<DocumentSnapshot> offers = querySnapshot.docs.toList();
                          DocumentSnapshot documentSnapshot = offers[index];
                          Offer offer = Offer.fromDocumentSnapshot(documentSnapshot);
                          return OfferWidget(
                             offer: offer,
                             onTapItem: (){
                             Navigator.pushNamed(
                                   context,
                                   "/offer-details",
                                   arguments: offer
                              );
                              },
                           );
                          }
                    ),
                    ),
                  );
              }
              return Container();
            },
          ),
        ],),
      ),
    );
  }
}
