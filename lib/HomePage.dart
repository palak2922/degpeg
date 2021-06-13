import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pages/Rounded_Button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Page1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //--------------------------------------------------------------------------------google sign in method

  bool _isLoggedIn = false;
  // User firebaseUser = FirebaseAuth.instance.currentUser;
  var userID;

  _login() async{
    try{
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
        setState(() {
          _isLoggedIn = true;
        });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      userID = prefs.setString('userID', googleUser.id);
      print(userID);

      userInformation(googleUser.id);

      Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Page1()
        ));

      return await FirebaseAuth.instance.signInWithCredential(credential);

    }
    catch(e){
      print(e);
    }
  }

  //==========================================================================================user information

  void userInformation(var id){
    firestore.collection("VideoStatus").doc(id).set(
        {
          "uid" : "$id",
          "viewcount" : "",
        }).then((_){
      print("success!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.only(
                  right: 30.0, left: 30, bottom: 20),
              child: RoundedButton(
                icon: Icon(FontAwesomeIcons.google, color: Colors.lightBlueAccent,),
                name: 'Continue With Google',
                color: Colors.lightBlueAccent,
                onpresses: (){
                  _login();
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}









