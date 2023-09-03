import 'package:ecotec/views/widgets/CustomButton.dart';
import 'package:ecotec/views/widgets/CustomTextInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/UserApp.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String _errorMessage = "";

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _loginUser(UserApp user){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password
    ).then((firebaseUser){
      Navigator.pushReplacementNamed(context, "/index");
    });
  }

  _validateInputs(){
    String email = _emailController.text;
    String password = _passwordController.text;

    if(email.isNotEmpty && email.contains("@")){
      if(password.isNotEmpty && password.length>6){

        UserApp user = UserApp();
        user.email = email;
        user.password = password;

        _loginUser(user);

      } else {
        setState(() {
          _errorMessage = "Senha inválida";
        });
      }
    } else {
      setState(() {
        _errorMessage = "E-mail inválido";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ecotec"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "images/logo.png",
                    width: 200,
                    height: 100,
                  ),
                ),
                CustomTextInput(
                  controller: _emailController,
                  hint: "E-mail",
                  autofocus: true,
                  type: TextInputType.emailAddress,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                ),
                CustomTextInput(
                    controller: _passwordController,
                    hint: "Senha",
                    obscure: true
                ),
                CustomButton(
                  text: "Entrar",
                  onPressed: _validateInputs,
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, "/index");
                    },
                    child: Text("Ir para anúncios")
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, "/register");
                    },
                    child: Text("Cadastrar")
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(_errorMessage, style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
