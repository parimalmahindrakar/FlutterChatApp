import 'package:flutter/material.dart';
import 'package:chat20/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:chat20/helper/constants.dart';
import 'package:chat20/views/conversation_room.dart';
class Search extends StatefulWidget {
  static String id_ = "searchScreen";
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchedString;
  DatabaseMethods dbm  = DatabaseMethods();

  QuerySnapshot searchSnapshots;

  String uname ;
  String uemail;

  initiateSearch(){
    dbm.getUserByUsername(searchedString).then((val){
      setState(() {
        searchSnapshots = val;
      });
    });
  }

  Widget searchList(){
    return searchSnapshots !=null ? ListView.builder(
        itemCount: searchSnapshots.docs.length,
        shrinkWrap: true,itemBuilder: (context,index){
      return SearchTile(
        username: searchSnapshots.docs[0].data()['name'].toString(),
        useremail:searchSnapshots.docs[0].data()['email'].toString(),
      );
    }): Container();
  }

  createChatRoomAndStartConversation(String username){

    if(username != Constants.myName){
      List<String> users = [username,Constants.myName];
      String chatRoomId = getChatRoomId(username,Constants.myName);
      Map<String,dynamic> chatRoomMap = {
        "users":users,
        "chatRoomId":chatRoomId
      };
      dbm.createChatRooom(chatRoomId, chatRoomMap);

      Navigator.push(context,MaterialPageRoute(
        builder: (context)=> ConversationRoom(chatRoomId)
      ));
    }else {
      print("You cannot send the messages ");
    }
  }

  Widget SearchTile({String username,String useremail}){
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0)

      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(username,style: TextStyle(
                  fontFamily: "jsp",
                  fontSize: 17.0
              ),),
              Text(useremail,style: TextStyle(
                  fontFamily: "jsp",
                  fontSize: 17.0
              ),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
                createChatRoomAndStartConversation(username);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
              child: Text("Message",style: TextStyle(
                  fontFamily: "jsp",
                  color: Colors.white,
                  fontSize: 17.0
              )),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Just Chat",
        style: TextStyle(
          fontFamily: "jsp",
          fontSize: 17.0
        ),),

      ),

      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x12111111),
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        onChanged: (val){
                            searchedString = val;
                        },
                        style: TextStyle(
                            fontFamily: "jsp",
                            fontSize: 17.0
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter name of user to be searched."
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                      },
                    child: Container(
                        child: Icon(Icons.search,size: 30.0,)),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}
getChatRoomId(String a, String b){
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}



//
//class SearchTile extends StatelessWidget {
//
//  final String username;
//  final String useremail;
//  SearchTile({this.username,this.useremail});
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(30.0)
//
//      ),
//      child: Row(
//        children: <Widget>[
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Text(username,style: TextStyle(
//                fontFamily: "jsp",
//                fontSize: 17.0
//              ),),
//              Text(useremail,style: TextStyle(
//                  fontFamily: "jsp",
//                  fontSize: 17.0
//              ),)
//            ],
//          ),
//          Spacer(),
//          GestureDetector(
//            onTap: (){
//
//            },
//            child: Container(
//              decoration: BoxDecoration(
//                color: Colors.blue,
//                borderRadius: BorderRadius.circular(30)
//              ),
//              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
//              child: Text("Message",style: TextStyle(
//                  fontFamily: "jsp",
//                  color: Colors.white,
//                  fontSize: 17.0
//              )),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}


