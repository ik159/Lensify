import 'package:flutter/material.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Baby Names',
     home: _handleWindowDisplay(),
   );
 }
}

Widget _handleWindowDisplay(){
  return StreamBuilder(
stream: FirebaseAuth.instance.onAuthStateChanged,
builder: (BuildContext context ,snapshot ){
  if(snapshot.connectionState == ConnectionState.waiting){
    return Center(child: Text("LOADING"));
  }
  else{
    if(snapshot.hasData){
      
      return MainScreen();
    }
    else{
      return LoginScreen();
    }
  }
},
  );
}