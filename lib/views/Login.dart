import 'package:ecotec/views/widgets/CustomButton.dart';
import 'package:ecotec/views/widgets/CustomTextInput.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


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
                  text: "Alterar",
                  onPressed: (){},
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    child: Text("Ir para anúncios")
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    child: Text("Cadastrar")
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("Alterar mensagem de erro", style: TextStyle(
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
