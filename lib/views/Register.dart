import 'package:ecotec/views/widgets/CustomButton.dart';
import 'package:ecotec/views/widgets/CustomTextInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/UserApp.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _LoginState();
}

class _LoginState extends State<Register> {

  String _errorMessage = "";

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _registerUser(UserApp user){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password
    ).then((firebaseUser) {
      Navigator.pushReplacementNamed(context, "/");
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

        _registerUser(user);

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
        title: Text("Cadastrar usuário"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                  text: "Cadastrar",
                  onPressed: _validateInputs,
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
