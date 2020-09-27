import 'package:chat20/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:chat20/widgets/widget.dart';
import 'chatRooms.dart';
import 'package:chat20/services/database.dart';
import 'package:chat20/helper/helperfunction.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  static String id = "signup_screen";
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  String email ;
  String password;
  String username;


  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods dbm = DatabaseMethods();
  HelperFunction helperFunction = HelperFunction();

  signMeUp(){
    if (formKey.currentState.validate()){

      Map<String,String> userInfo = {
        "name":username,
        "email":email
      };

      HelperFunction.saveUserEmailInSharePreference(email);
      HelperFunction.saveUserNameInSharePreference(username);
      setState(() {
        isLoading=true;
      });

        authMethods.signUpWithEmailAndPassword(email,password).then((value){
          print("inserted user $value");
          dbm.uploadUserInfo(userInfo);
          HelperFunction.saveUserLoggedInSharePreference(true);
          Navigator.pushNamed(context, ChatRoom.id);
          isLoading = false;
        });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "Just Chat"),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : Container(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      onChanged:(val){
                        username = val;
                      },
                      validator: (val){
                        return  val.isEmpty || val.length<3 ?  "Please provide correct username." : null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontFamily: "jsp",
                          fontSize: 17.0
                      ),
                      decoration: InputDecoration(
                          hintText: "username"
                      ),
                    ),
                    TextFormField(
                      validator: (val){
                        return  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+").hasMatch(val) ? null : "Please provide valid email-id !";
                      },
                      onChanged: (val){
                        email = val;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontFamily: "jsp",
                          fontSize: 17.0
                      ),
                      decoration: InputDecoration(
                          hintText: "email"
                      ),
                    ),
                    TextFormField(
                      validator: (val){
                        return val.length>6  ? null: "Please provide password with 6+ characters.";
                      },
                      onChanged: (val){
                        password = val;
                      },
                      obscureText: true,
                      style: TextStyle(
                          fontFamily: "jsp",
                          fontSize: 17.0
                      ),
                      decoration: InputDecoration(
                        hintText: "password ",
                      ),
                    )
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
                  signMeUp();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Sign Up",style: TextStyle(fontFamily: "jsp",fontSize: 20.0,color: Colors.white),),
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
                child: Text("Sign Up With Google",style: TextStyle(fontFamily: "jsp",fontSize: 20.0,color: Colors.white),),
              ),
              SizedBox(height: 25.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have account?", style: TextStyle(fontFamily: "jsp",fontSize: 17.0),),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Log In Now !", style: TextStyle(fontFamily: "jsp",decoration: TextDecoration.underline,fontSize: 17.0),)),
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
