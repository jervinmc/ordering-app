import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_7.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ordering_app/pages/config/global.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
 dynamic args = Get.arguments;
  @override
  _ChatPageState createState() => _ChatPageState(args);
}

final ScrollController _controller = ScrollController();

class _ChatPageState extends State<ChatPage> {
  List args;
  
  _ChatPageState(this.args);
  late Channel _channel;
  bool isListening = false;
  void _listen() {}
  late String channel1;
  static String BASE_URL = '' + Global.url + '/';
  List conversations = [];
  TextEditingController _message = new TextEditingController();
  void sendMessage(message) async {
     final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var image_profile= prefs.getString("_image")!;
     var params = {
     "user_id":_id,
     "users_profile":image_profile
   };
     final response = await http.post(Uri.parse(Global.url+'/'+'notification_message/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    setState(() {
      conversations.add(
          {"message": message, "type": BubbleType.sendBubble, "isMe": true});
      // responseMessage(_message.text);
      _message.text = '';
    });
    send(message);
    _scrollDown();
  }
  void send(message) {
    print(args[0]);
    var params = {
      "value": message,
      "channel": args[0],
      "chat": message,
      "account_type": "Customer"
    };
    final response = http.post(Uri.parse(BASE_URL + 'sendMessage/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    // String jsonsDataString = response.body.toString();
    // final _data = jsonDecode(jsonsDataString);
    // print(_data);
    setState(() {
      // conversations.add({"message":_data['data'],"type":BubbleType.sendBubble,"isMe":false});
    });
  }

  void showChat() async {

    var params = {"channel": args[0]};
    final response = await http.post(
        Uri.parse(Global.url + '/' + 'chatgetall/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    String jsonsDataString = response.body.toString();
    final datas = jsonDecode(jsonsDataString);
    setState(() {
      conversations = [];
      print('erase');
    });
    for (int x = 0; x < datas.length; x++) {
      setState(() {
        if (datas[x]['account_type'] == 'Merchant') {
          conversations.add({
            "message": datas[x]['chat'],
            "type": BubbleType.sendBubble,
            "isMe": false
          });
        } else {
          conversations.add({
            "message": datas[x]['chat'],
            "type": BubbleType.sendBubble,
            "isMe": true
          });
        }
      });
      setState(() {
        
      });
    }
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void responseMessage(message) async {
    var params = {
      "value": message,
    };
    final response = await http.post(Uri.parse('' + 'chat'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    String jsonsDataString = response.body.toString();
    final _data = jsonDecode(jsonsDataString);
    print(_data);
    setState(() {
      conversations.add({
        "message": _data['data'],
        "type": BubbleType.sendBubble,
        "isMe": false
      });
    });
    _scrollDown();
  }

  void initState() {
    super.initState();
    // getData();
    print(args);
    showChat();
    
    _initPusher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff222f3e),
          title: Text('Chat'),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                  controller: _controller,
                  itemCount: conversations.length,
                  itemBuilder: (BuildContext context, index) {
                    return conversations[index]['isMe']
                        ? getSenderView(
                            ChatBubbleClipper7(
                                type: conversations[index]['type']),
                            context,
                            conversations[index]['message'])
                        : getReceiverView(
                            ChatBubbleClipper7(
                                type: conversations[index]['type']),
                            context,
                            conversations[index]['message']);
                  }),
            ),
            new Positioned(
                bottom: 0.0,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  width: 400,
                  child: Row(
                    children: [
                      // isListening
                      //     ? IconButton(
                      //         onPressed: () {
                      //           _listen();
                      //         },
                      //         icon: Icon(Icons.close))
                      //     : IconButton(
                      //         onPressed: () {
                      //           _listen();
                      //         },
                      //         icon: Icon(Icons.mic)),
                      Expanded(
                        child: new TextField(
                          controller: _message,
                          decoration: const InputDecoration.collapsed(
                              hintText: "Send a message."),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            sendMessage(_message.text);
                          },
                          icon: Icon(Icons.send)),
                    ],
                  ),
                )),
          ],
        ));
  }

  Future<void> _initPusher() async {
    try {
      Pusher.init('33efacb6a0d9c7baad00', PusherOptions(cluster: 'ap1'));
      print('okay');
    } catch (e) {
      print(e);
    }
    Pusher.connect(onConnectionStateChange: (val) {
      print(val.currentState);
    }, onError: (error) {
      print(error);
    });
    _channel = await Pusher.subscribe(args[0]);
    _channel.bind('my-test', (onEvent) {
      print(onEvent.data);
      showChat();
    });
  }

  getSenderView(CustomClipper clipper, BuildContext context, String message) =>
      ChatBubble(
        clipper: clipper,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: Colors.blue,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  getReceiverView(
          CustomClipper clipper, BuildContext context, String message) =>
      ChatBubble(
        clipper: clipper,
        backGroundColor: Color(0xffE7E7ED),
        margin: EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
}
