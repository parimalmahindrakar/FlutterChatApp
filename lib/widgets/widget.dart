import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context,String title){
  return  AppBar(
    title: Text(title,
    style: TextStyle(
    fontFamily: "jsp",
    ),
      ),
    centerTitle: true,
    );
}

