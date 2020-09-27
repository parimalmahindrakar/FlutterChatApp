import 'package:chat20/helper/authenticate.dart';
import 'package:chat20/views/chatRooms.dart';
import 'package:flutter/material.dart';
import 'views/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/signin.dart';
import 'views/search.dart';
import 'views/conversation_room.dart';
import 'helper/helperfunction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isUserLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    // TODO: implement initState
    super.initState();
  }


  getLoggedInState() async {
    await HelperFunction.getUserLoggedInSharePreference().then((value) {
     setState(() {
       isUserLoggedIn = value;
     });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: isUserLoggedIn!=null ? isUserLoggedIn ? ChatRoom() : Authenticate():Authenticate(),
      initialRoute: SignUp.id,
      routes: {
        ChatRoom.id:(context)=>ChatRoom(),
        SignIn.id_:(context)=>Authenticate(),
        Search.id_: (context)=>Search(),
//        ConversationRoom.id_:(context)=>ConversationRoom()

      },
    );
  }
}
