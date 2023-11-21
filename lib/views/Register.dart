import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotec/views/widgets/CustomButton.dart';
import 'package:ecotec/views/widgets/CustomTextInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/Validador.dart';

import '../models/UserApp.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _LoginState();
}

class _LoginState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  late UserApp _userApp;
  File? _profilePic;

  String _errorMessage = "";

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  _controller(){
    return TextEditingController();
  }

  _selectImageFromGallery() async{
    final selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if ( selectedImage != null ){
      setState(() {
        _profilePic = File(selectedImage.path);
      });
    }
  }

  Future _uploadImages() async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference rootDir = storage.ref();

    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference file = rootDir
        .child("profile_pics")
        .child(_userApp.idUser)
        .child(fileName);

      UploadTask uploadTask = file.putFile(_profilePic!);
      TaskSnapshot taskSnapshot = await uploadTask;

      String url = await taskSnapshot.ref.getDownloadURL();
      _userApp.profilePhotoUrl = url;

    print("imagem: ${url}");
    }

  _registerUser(UserApp user) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password
    ).then((firebaseUser) async {
      _userApp.idUser = firebaseUser.user!.uid;

      await _uploadImages();

      db.collection("users")
        .doc(firebaseUser.user!.uid)
        .set(_userApp!.toMap());
      Navigator.pushReplacementNamed(context, "/");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userApp = UserApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar usuário",
            style: TextStyle(color: Colors.white)
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FormField<File>(
                    builder: (state){
                      if(_profilePic == null){
                        return GestureDetector(
                          onTap: (){
                            _selectImageFromGallery();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[400],
                            radius: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.white,
                                ),
                                Text("Sua foto",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }else{
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          child: GestureDetector(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.file(_profilePic!),
                                        TextButton(
                                          child: Text("Excluir"),
                                          style: TextButton.styleFrom(
                                              primary: Colors.red),
                                          onPressed: (){
                                            setState(() {
                                              _profilePic = null;
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage: FileImage(
                                _profilePic!,
                              ),
                              radius: 80,
                            ),
                          )
                        );
                      }
                    }
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 30),
                    child: CustomTextInput(
                      controller: _controller(),
                      hint: "Nome e sobrenome",
                      type: TextInputType.text,
                      onSaved: (name){
                        _userApp.name = name!;
                      },
                      validator: (value){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                            .maxLength(200, msg: "Máximo de 200 caractéres")
                            .valido(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    child: CustomTextInput(
                      controller: _emailController,
                      hint: "E-mail",
                      type: TextInputType.emailAddress,
                      onSaved: (email){
                        _userApp.email = email!;
                      },
                      validator: (value){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                            .add(Validar.EMAIL, msg: "Digite um E-mail válido!")
                            .valido(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: CustomTextInput(
                      controller: _passwordController,
                      hint: "Senha",
                      obscure: true,
                      onSaved: (password){
                        _userApp.password = password!;
                      },
                      validator: (value){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                            .valido(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: CustomTextInput(
                      controller: _controller(),
                      hint: "Telefone",
                      type: TextInputType.phone,
                      onSaved: (phone){
                        _userApp.phone = phone!;
                      },
                      validator: (value){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                            .valido(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: CustomButton(
                      text: "Cadastrar",
                      onPressed: (){
                        print("sei");
                        if(_formKey.currentState!.validate()){
                          print("valido");
                          _formKey.currentState!.save();
                          _registerUser(_userApp);
                        }
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(_errorMessage, style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red
                      ),
                    ),
                  ),
                ]
              ),
            )
          ),
        ),
      ),
    );
  }
}
