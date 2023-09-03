import 'package:ecotec/views/Login.dart';
import 'package:ecotec/views/Register.dart';
import 'package:flutter/material.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/login":
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/register":
        return MaterialPageRoute(
            builder: (_) => Register()
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