import 'package:ecotec/main.dart';
import 'package:flutter/material.dart';

import 'CustomSearchBar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final double height;
  final CustomSearchBar searchBar;
  final List<Widget> actions;

  CustomAppBar({required this.context, required this.height, required this.searchBar, required this.actions});

  @override
  Size get preferredSize => Size(MediaQuery.of(context).size.width, height + 80);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
                child: AppBar(
                title: Text("Ecotec"),
                actions: actions,
                shadowColor: Colors.transparent,
            ),
          ),
          color: ecotecTheme.colorScheme.primary,
          height: height + 70,
          width: MediaQuery.of(context).size.width,
        ),
        Container(),
        Positioned(
          top: 100.0,
          left: 15.0,
          right: 15.0,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              child: searchBar,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F5),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}
