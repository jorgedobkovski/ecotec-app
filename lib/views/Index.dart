import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {

  List<String> _menuItems = [""];

  _logoutUser() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamed(context, "/login");
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
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case "Entrar/Cadastrar":
        Navigator.pushNamed(context, "/login");
        break;
      case "Deslogar":
        _logoutUser();
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ecotec"),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: _selectedMenuItem,
            itemBuilder: (context){
              return _menuItems.map((String item){
                return PopupMenuItem<String>(
                    value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[
          Row(children: <Widget>[
              Text("Filtros")
            ],
          ),
          Column(children: <Widget>[
              Text("Anuncios")
          ],)
        ],),
      ),
    );
  }
}
