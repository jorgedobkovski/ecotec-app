import 'package:brasil_fields/brasil_fields.dart';
import 'package:ecotec/main.dart';
import 'package:flutter/material.dart';

class Config{
  static List<DropdownMenuItem<String>> getCategories(){
    List<DropdownMenuItem<String>> dropdownItems = [];

    dropdownItems.add(
      DropdownMenuItem(child: Text(
        "Categoria", style: TextStyle(
        color: ecotecTheme.colorScheme.primary,
      ),
      ), value: null,
      ),
    );
    
    dropdownItems.add(
      DropdownMenuItem(child: Text("Artesanato"), value: "artes",),
    );

    dropdownItems.add(
      DropdownMenuItem(child: Text("Brechó"), value: "textil",),
    );

    dropdownItems.add(
      DropdownMenuItem(child: Text("Eletrônicos"), value: "eletro",),
    );

    dropdownItems.add(
      DropdownMenuItem(child: Text("Orgânico"), value: "organico",),
    );

    dropdownItems.add(
      DropdownMenuItem(child: Text("Outros"), value: "outros",),
    );

    return dropdownItems;
  }

  static List<DropdownMenuItem<String>> getLocations(){
    List<DropdownMenuItem<String>> dropdownItems = [];

    dropdownItems.add(
      DropdownMenuItem(child: Text(
        "Localização", style: TextStyle(
        color: ecotecTheme.colorScheme.primary,
      ),
      ), value: null,
      ),
    );

    for(var location in Estados.listaEstadosSigla){
      dropdownItems.add(
        DropdownMenuItem(child: Text(location), value: location,)
      );
    }

    return dropdownItems;
  }

}