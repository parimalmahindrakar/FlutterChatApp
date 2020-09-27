import 'package:chat20/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chat20/helper/constants.dart';
import 'package:flutter/rendering.dart';

class ConversationRoom extends StatefulWidget {

  String chatRoomId;
  ConversationRoom(this.chatRoomId);

  static String id_ = "conversationRoom";
  @override
  _ConversationRoomState createState() => _ConversationRoomState();
}

class _ConversationRoomState extends State<ConversationRoom> {

  DatabaseMethods dbm = DatabaseMethods();
  String textedMessage;
  Stream chatMessageStream;
  TextEditingController textEditingController = TextEditingController();

  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context,snapshot){
      return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            return MessageTile(
                 message: snapshot.data.docs[index].data()['message'].toString(),
              isSentByMe: snapshot.data.docs[index].data()['send'] == Constants.myName
            );
          }) : Container();
      },
    );
  }

  sendMessage(){
      Map<String,dynamic> messageMap = {
        "message": textEditingController.text,
        "send":Constants.myName,
        "time":DateTime.now().millisecondsSinceEpoch
      };
    dbm.addConversationMessages(widget.chatRoomId, messageMap);
      textEditingController.text = "";
  }

  @override
  void initState() {
    // TODO: implement initState
    dbm.getConversationMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Just Chat",
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: "jsp"
        ),),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x12111111),
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        
                        child: TextField(

                          controller: textEditingController,
                          style: TextStyle(
                              fontFamily: "jsp",
                              fontSize: 17.0
                          ),
                          decoration: InputDecoration(
                              hintText: "Type here !"
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Container(
                          child: Icon(Icons.message,size: 30.0,)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MessageTile extends StatelessWidget {

  final String message;
  final bool isSentByMe;
  MessageTile({this.message,this.isSentByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSentByMe ? 0:24,right:isSentByMe ? 24:0 ),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(18),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: isSentByMe ? Colors.blue : Colors.grey,
          borderRadius: isSentByMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              ) :
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23),
          )
        ),
        child: Text(
          message,
          style: TextStyle(
            fontFamily: "jsp",
            fontSize: 20.0,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
