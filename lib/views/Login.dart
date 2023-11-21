import 'package:ecotec/main.dart';
import 'package:ecotec/views/widgets/CustomButton.dart';
import 'package:ecotec/views/widgets/CustomLoginTextInput.dart';
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

  _loginUser(UserApp user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) {
      Navigator.pushReplacementNamed(context, "/index");
    });
  }

  _validateInputs() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length > 6) {
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
      body: Container(
        color: ecotecTheme.colorScheme.primary,
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "images/logo-white.png",
                    height: 50,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CustomLoginTextInput(
                        controller: _emailController,
                        hint: "E-mail",
                        autofocus: true,
                        type: TextInputType.emailAddress,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      CustomLoginTextInput(
                          controller: _passwordController,
                          hint: "Senha",
                          obscure: true),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: GestureDetector(
                          onTap: _validateInputs,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(32, 16, 31, 16),
                              decoration: BoxDecoration(
                                  color: ecotecTheme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: Center(
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/index");
                          },
                          child: Container(
                              padding: EdgeInsets.fromLTRB(32, 16, 31, 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                  color: Colors.black45,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Entrar como convidado",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black45,
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Text(
                        _errorMessage,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, "/register");
                          },
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Novo no EcoTec? ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "Cadastre-se",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
