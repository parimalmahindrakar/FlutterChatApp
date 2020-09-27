import 'package:chat20/helper/helperfunction.dart';
import 'package:chat20/services/database.dart';
import 'package:chat20/views/conversation_room.dart';
import 'package:chat20/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:chat20/services/auth.dart';
import 'search.dart';
import 'package:chat20/helper/constants.dart';

class ChatRoom extends StatefulWidget {
  static String id = "chat_room";
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods dbm = DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index){
              return ChatRoomsTile(
            snapshot.data.docs[index].data()["chatRoomId"].toString()
                .replaceAll("_", "").replaceAll(Constants.myName,""),
                  snapshot.data.docs[index].data()["chatRoomId"]
              );
            }
        ):Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameInSharePreference();
    dbm.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomStream = val;
      });
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Just Chat",
        style: TextStyle(
          fontFamily: "jsp",
          fontSize: 20.0
        ),),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
             authMethods.signOut();
             Navigator.pushNamed(context, SignIn.id_);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.search
        ),
        onPressed: (){
        Navigator.pushNamed(context, Search.id_);
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {

  final String Username;
  final String chatRoomId;
  ChatRoomsTile(this.Username,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(
          builder: (context)=>ConversationRoom(chatRoomId)
        ));
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${Username.substring(0,1).toUpperCase()}",style: TextStyle(
                  fontSize: 20,
                  fontFamily: "jsp"
              )),
            ),
            SizedBox(width: 8,),
            Text(Username,style: TextStyle(
              fontSize: 20,
              fontFamily: "jsp"
            ),)
          ],
        ),
      ),
    );
  }
}


