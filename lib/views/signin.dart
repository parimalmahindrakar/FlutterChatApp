import 'package:chat20/services/auth.dart';
import 'package:chat20/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chat20/widgets/widget.dart';
import 'package:flutter/widgets.dart';
import 'package:chat20/helper/helperfunction.dart';
import 'chatRooms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  static String id_ = "signin_page";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


  String password;
  String email;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot snapshot;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods dbm = DatabaseMethods();

  signIn(){
    if(formKey.currentState.validate()){
      HelperFunction.saveUserEmailInSharePreference(email);

      print(email);
      print(password);
      //TODO function to get userDetails
      setState(() {
        isLoading = true;
      });
      dbm.getUserByUserEmail(email).then((val){
        snapshot = val;
        HelperFunction.saveUserNameInSharePreference(snapshot.docs[0].data()["name"].toString());
      });
      authMethods.signInWithEmailAndPassword(email, password).then((value) {
        if(value!=null){
          HelperFunction.saveUserLoggedInSharePreference(true);
          Navigator.pushNamed(context, ChatRoom.id);
        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,"Just Chat!"),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (val){
                        return  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+").hasMatch(val) ? null : "Please provide valid email-id !";
                      },
                      onChanged: (val){
                        email=val;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontFamily: "jsp",
                          fontSize: 17.0
                      ),
                      decoration: InputDecoration(
                          hintText: "Enter the email."
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val){
                        return val.length>6  ? null: "Please provide password with 6+ characters.";
                      },
                      onChanged: (val){
                        password = val;
                      },
                      style: TextStyle(
                          fontFamily: "jsp",
                          fontSize: 17.0
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter the password.",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0,),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Text("Forgot Password ?",style: TextStyle(fontFamily: "jsp",fontSize: 17.0),),
                ),
              ),
              SizedBox(height: 16.0,),
              GestureDetector(
                onTap: (){
                  //TODO
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Sign In",style: TextStyle(fontFamily: "jsp",fontSize: 20.0,color: Colors.white),),
                ),
              ),
              SizedBox(height: 15.0,),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Sign In With Google",style: TextStyle(fontFamily: "jsp",fontSize: 20.0,color: Colors.white),),
              ),
              SizedBox(height: 25.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't you have account?", style: TextStyle(fontFamily: "jsp",fontSize: 17.0),),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Register Now !", style: TextStyle(fontFamily: "jsp",decoration: TextDecoration.underline,fontSize: 17.0),)),
                  )
                ],
              ),
              SizedBox(height: 50.0,)
            ],
          ),
        ),
      ),
    );
  }
}


