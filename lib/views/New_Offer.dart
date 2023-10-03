import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotec/util/Config.dart';
import 'package:ecotec/views/widgets/CustomButton.dart';
import 'package:ecotec/views/widgets/CustomTextInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/Validador.dart';

import '../models/Offer.dart';

class NewOffer extends StatefulWidget {
  const NewOffer({super.key});

  @override
  State<NewOffer> createState() => _NewOfferState();
}

class _NewOfferState extends State<NewOffer> {

  final _formKey = GlobalKey<FormState>();
  List<File> _imagesList = List.empty(growable: true);
  List<DropdownMenuItem<String>> _listDropLocation =List.empty(growable: true);
  String _selectedLocation = "";
  List<DropdownMenuItem<String>> _listDropCategory = List.empty(growable: true);
  String _selectedCategory = "";

  late Offer _offer;
  late BuildContext _dialogContext;

  _controller(){
    return TextEditingController();
  }

  _selectImageFromGallery() async{
    final selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if ( selectedImage != null ){
      setState(() {
        _imagesList.add(File(selectedImage.path));
      });
    }
  }

  Future _uploadImages() async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference rootDir = storage.ref();

    for(var image in _imagesList){
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference file = rootDir
        .child("my_offers")
        .child(_offer.id)
        .child(fileName);

      UploadTask uploadTask = file.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;

      String url = await taskSnapshot.ref.getDownloadURL();
      _offer.pictures.add(url);
    }

  }

  _loadDropdownItems(){
    _listDropCategory = Config.getCategories();
    _listDropLocation = Config.getLocations();
  }

  _showDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Salvando anúncio...")
              ],
            ),
          );
        }
    );
  }



  _saveOffer() async{
    _showDialog(_dialogContext);

    await _uploadImages();

    FirebaseAuth auth = FirebaseAuth.instance;
    User currentUser = await auth.currentUser!;
    String currentUserId = currentUser.uid;

    _offer.userId = currentUserId;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("my_offers")
    .doc(currentUserId)
    .collection("offers")
    .doc(_offer.id)
    .set(_offer.toMap()).then((_){

      db.collection("offers")
          .doc(_offer.id)
          .set(_offer.toMap()).then((_){
            Navigator.pop(_dialogContext);
            Navigator.pop(context);
      });

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDropdownItems();
    _offer = Offer.generateId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormField<List>(
                  validator: (images){
                    if(images!.isEmpty){
                      return "Selecione uma imagem!";
                    }
                    return null;
                  },
                  initialValue: _imagesList,
                  builder: (state){
                    return Column(children: <Widget>[
                      Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imagesList.length + 1,
                          itemBuilder: (context, index){
                            if(index == _imagesList.length){
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: (){
                                    _selectImageFromGallery();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[400],
                                    radius: 50,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Adicionar",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            if(_imagesList.isNotEmpty){
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Image.file(_imagesList[index]),
                                            TextButton(
                                              child: Text("Excluir"),
                                              style: TextButton.styleFrom(
                                                primary: Colors.red,
                                              ),
                                              onPressed: (){
                                                setState(() {
                                                  _imagesList.removeAt(index);
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(_imagesList[index]),
                                    child: Container(
                                      color: Color.fromRGBO(255, 255, 255, 0.4),
                                      alignment: Alignment.center,
                                      child: Icon(Icons.delete, color: Colors.red),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      if(state.hasError)
                        Container(
                          child: Text(
                            "[${state.errorText}]",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        )
                    ],);
                  },
                ),
                Row(children: <Widget>[
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: DropdownButtonFormField(
                      hint: Text("Região"),
                      onSaved: (location){
                        _offer.location = location!;
                      },
                      style: TextStyle(
                          color: Colors.black,
                          fontSize:20
                      ),
                      items: _listDropLocation,
                      validator: (value){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                            .valido(value);
                      },
                      onChanged: (value){
                        setState(() {
                          _selectedLocation = value!;
                        });
                      },
                    ),
                  )),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: DropdownButtonFormField(
                      hint: Text("Categoria"),
                      onSaved: (category){
                        _offer.category = category!;
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                      ),
                      items: _listDropCategory,
                      validator: (value){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                            .valido(value);
                      },
                      onChanged: (value){
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ))
                ],),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: CustomTextInput(
                    controller: _controller(),
                    hint: "Título",
                    onSaved: (title){
                      _offer.title = title!;
                      _offer.titleToLowerCase = title!.toLowerCase();
                    },
                    validator: (value){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                          .valido(value);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: CustomTextInput(
                    controller: _controller(),
                    hint: "Preço",
                    onSaved: (price){
                      _offer.price = price!;
                    },
                    inputFotmatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true, casasDecimais: 2),
                    ],
                    type: TextInputType.number,
                    validator: (value){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                          .valido(value);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: CustomTextInput(
                    controller: _controller(),
                    hint: "Descrição",
                    onSaved: (description){
                      _offer.description = description!;
                    },
                    maxLines: null,
                    validator: (value){
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                          .valido(value);
                    },
                  ),
                ),
                CustomButton(
                    text: "Cadastrar anúncio",
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        _dialogContext = context;
                        _saveOffer();
                      }
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
