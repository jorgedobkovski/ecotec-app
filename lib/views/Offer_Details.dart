import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotec/main.dart';
import 'package:ecotec/models/Offer.dart';
import 'package:ecotec/models/UserApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class OfferDetails extends StatefulWidget {

  final Offer offer;
  OfferDetails(this.offer);

  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {

  late Offer _offer;
  late UserApp? _userApp;
  String _userName = "";
  String _userPic = "https://firebasestorage.googleapis.com/v0/b/ecotec-30a76.appspot.com/o/profile_pics%2FwzTa3zTkzVdm5L3Y5XsfnfNqKgA3%2Fnull.jpg?alt=media&token=3c9f7867-3073-44ca-8e0b-7bcfe62bebb5";

  List<Widget> _getImagesList(){
    List<String> imagesUrlList = _offer.pictures;
    return imagesUrlList.map((url){
      return Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          )
        ),
      );
    }).toList();
  }

  Future<void> fetchUserById(String userId) async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userDoc = await usersCollection.doc(userId).get();

      if (userDoc.exists) {
        _userApp = UserApp.fromDocumentSnapshot(userDoc);
        setState(() {
          _userName = _userApp!.name;
          _userPic = _userApp!.profilePhotoUrl;
        });
      } else {
        print("User not found");
      }
    } catch (e) {
      print('Error fetching user by ID: $e');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offer = widget.offer;
    fetchUserById(_offer.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anúncio"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(children: [
            SizedBox(
              height: 250,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return new Image.network(
                    _offer.pictures[index],
                    fit: BoxFit.cover,
                  );
                },
                indicatorLayout: PageIndicatorLayout.NONE,
                autoplay: false,
                itemCount: _offer.pictures.length,
                pagination: new SwiperPagination(
                    builder: new DotSwiperPaginationBuilder(
                        color: Colors.white30,
                        activeColor: Colors.white,
                        size: 10.0,
                        activeSize: 10.0),
                ),
                fade: 1.0,
                viewportFraction: 1,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_offer.price,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: ecotecTheme.colorScheme.primary,
                    ),
                  ),
                  Text(_offer.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(),
                  ),
                  Text("Descrição",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(_offer.description,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(),
                  ),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(_userPic!),
                        radius: 30
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_userName!,
                                style:TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )
                            ),
                            Text("Ver perfil",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 45),
            ),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: GestureDetector(
          child: Container(
            child: Text(
              "Contactar vendedor",
              style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: ecotecTheme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(30)
            ),
          ),
          onTap: (){

          },
          ),
        )
        ]),
    );
  }
}
