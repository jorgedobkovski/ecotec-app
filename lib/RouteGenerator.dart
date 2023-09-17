import 'package:ecotec/models/Offer.dart';
import 'package:ecotec/views/Index.dart';
import 'package:ecotec/views/Login.dart';
import 'package:ecotec/views/My_Offers.dart';
import 'package:ecotec/views/New_Offer.dart';
import 'package:ecotec/views/Offer_Details.dart';
import 'package:ecotec/views/Register.dart';
import 'package:flutter/material.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name) {
      case "/index":
        return MaterialPageRoute(
            builder: (_) => Index()
        );
      case "/login":
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/register":
        return MaterialPageRoute(
            builder: (_) => Register()
        );
      case "/new-offer":
        return MaterialPageRoute(
            builder: (_) => NewOffer()
        );
      case "/my-offers":
        return MaterialPageRoute(
            builder: (_) => MyOffers()
        );
      case "/offer-details":
        return MaterialPageRoute(
            builder: (_) => OfferDetails(args as Offer)
        );
      default:
        return _erroRota();
    }
  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada"),
        ),
        body: Center(
          child: Text("Tela não encontrada"),
        ),
      );
    });
  }

}