import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/constant/color.dart';

import 'home_Page.dart';
class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 2),(){
      Navigator.pushReplacement(
          context,
         MaterialPageRoute(builder: (context)=>homepage()));

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(


       decoration: BoxDecoration(
         image: DecorationImage(
          image:AssetImage("assets/images/splash.png"),
           fit: BoxFit.fill



       ),





      )
      )
    );
  }
}
