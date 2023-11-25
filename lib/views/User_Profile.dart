import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotec/main.dart';
import 'package:ecotec/models/Offer.dart';
import 'package:ecotec/models/UserApp.dart';
import 'package:ecotec/views/widgets/OfferWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserProfile extends StatefulWidget {
  final UserApp userApp;

  UserProfile(this.userApp);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late UserApp _user;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _userName = "";
  String _userPic =
      "https://firebasestorage.googleapis.com/v0/b/ecotec-30a76.appspot.com/o/profile_pics%2FwzTa3zTkzVdm5L3Y5XsfnfNqKgA3%2Fnull.jpg?alt=media&token=3c9f7867-3073-44ca-8e0b-7bcfe62bebb5";

  Future<void> fetchUserById(String userId) async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userDoc = await usersCollection.doc(userId).get();

      if (userDoc.exists) {
        _user = UserApp.fromDocumentSnapshot(userDoc);
        setState(() {
          _userName = _user!.name;
          _userPic = _user!.profilePhotoUrl;
        });
      } else {
        print("User not found");
      }
    } catch (e) {
      print('Error fetching user by ID: $e');
    }
  }

  Future<Stream<QuerySnapshot>> _listenerOffers(userId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream =
        db.collection("my_offers").doc(userId).collection("offers").snapshots();

    stream.listen((data) {
      _controller.add(data);
    });

    return stream;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = widget.userApp;
    fetchUserById(_user.idUser);
    _listenerOffers(_user.idUser);
  }

  @override
  Widget build(BuildContext context) {
    var loadingData = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando anúncios..."),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: ecotecTheme.colorScheme.primary,
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(_user.profilePhotoUrl),
                  radius: 75,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          _user.name,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: Text(
                          "Amo ecologia desde que fui concebido. Me formei em biologia e reciclar é meu hobby. #LixoÉLuxo",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Expanded(
            child: StreamBuilder(
              stream: _controller.stream,
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
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (_, index) {
                          List<DocumentSnapshot> offers =
                              querySnapshot.docs.toList();
                          DocumentSnapshot documentSnapshot = offers[index];
                          Offer offer =
                              Offer.fromDocumentSnapshot(documentSnapshot);

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: OfferWidget(
                              offer: offer,
                              onTapItem: () {
                                Navigator.pushNamed(context, "/offer-details",
                                    arguments: offer);
                              },
                            ),
                          );
                        });
                }
                return Container();
              },
            ),
          )
        ],
      ),
    );
  }
}
