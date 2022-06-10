import 'package:flutter/material.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ordering_app/pages/config/global.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


   
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
class MostBuy extends StatefulWidget {
  const MostBuy({Key? key}) : super(key: key);

  @override
  _MostBuyState createState() => _MostBuyState();
}

class _MostBuyState extends State<MostBuy> {
  TextEditingController _search = new TextEditingController();
  final List<String> imgList = [
  'https://anongulam.s3.amazonaws.com/pic1.jpeg',
  'https://anongulam.s3.amazonaws.com/pic10.jpeg',
  'https://anongulam.s3.amazonaws.com/pic11.png',
];
  late Channel _channel;
String _email ='';
  bool _load =false;
  List data = [];
    List data_breakfast = [];
    List data_lunch = [];
   String category_data = "";
    List data_dinner = [];
    List data_recommend = [];
    bool isLoggedin = false;
   late String channel ;
   static String BASE_URL = '' + Global.url + '/mostbuy/';
   List feature = [];
  Future<String> getData() async {
    _load = true;
    final prefs = await SharedPreferences.getInstance();
      if(prefs.getBool("isLoggedIn")==null ||prefs.getBool("isLoggedIn")==false  ){
       isLoggedin = false;
     }
     else{
        isLoggedin =true;
     }
      _email = prefs.getString("_email").toString();
      channel = prefs.getString("_channel").toString();
      print(channel);
    setState(() {
      
    });
    var _id = prefs.getInt("_id");
    final response = await http.get(
        Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"});
        String jsonsDataString = response.body.toString();
      final _data = jsonDecode(jsonsDataString);
      data = data;
      print(_data);
        setState(() {
            try {
               data = _data;
              print(data.length);
              print(response);
          
            } finally {
              _load = false;
            }
          });
    return "";
  }

  @override
  void initState() {
 
    // TODO: implement initState
    super.initState();
    getData();
    _initPusher();
     tz.initializeTimeZones();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Most buy'),
        backgroundColor: Color(0xff222f3e),
      ),
      body: ListView(
        children: [
          // Container(
          //   padding: EdgeInsets.all(15),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       feature.length==0 ? Text('') :
          //       InkWell(
          //         child:Container(
          //         child:Image.network("${feature[2]}"),
          //       )
          //       ,
          //       onTap:() => {
          //           Get.toNamed('/details',arguments:['${feature[2]}','${feature[0]}','${feature[1]}'])
          //       }
          //       ),
          //        feature.length!=0 ? Column(children:[Text(feature[1],style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.bold))],crossAxisAlignment:CrossAxisAlignment.center) : Text('')
              
          //     ],
          //   ),
          // ),
          // Container(
          //   padding: EdgeInsets.all(10),
          //   child: Text(
          //     "Recommended Product",
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          //   ),
          // ),
          _load
                ? Container(
                    color: Colors.white10,
                    width: 70.0,
                    height: 70.0,
                    child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Center(
                            child: const CircularProgressIndicator())),
                  )
                : Text(''),
          Container(
        
            child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                if(isLoggedin){
                  Get.toNamed('/details',arguments:["${data[index]['image']}","${data[index]['id']}","${data[index]['product_name']}","${data[index]['price']}","${data[index]['stocks']}","${data[index]['descriptions']}"]);
                }
                else{
                   Navigator.pop(context);
                  Get.toNamed('/starting');
                }
              },
              child: ProductCard(
                  name: data[index]['product_name'].toString(),
                  picture: data[index]['image'],
                  price: data[index]['price'].toString()),
            );
          }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/search');
          // Add your onPressed code here!
        },
        backgroundColor: Color(0xff222f3e),
        child: const Icon(Icons.search),
      ),
    );
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
    _channel = await Pusher.subscribe('notif');
    _channel.bind('my-test', (onEvent) {
       var data = jsonDecode(onEvent.data);
      print(data['message']);
      NotificationService().showNotification(1,"New Notification" , data['message'], 1);
    
    });
  }
}


class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      required this.name,
      required this.picture,
      required this.price})
      : super(key: key);
  final name;
  final picture;
  final price;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: name,
        child: Material(
          child: InkWell(
            child: GridTile(
              child: Image.network(
                picture,
                fit: BoxFit.cover,
              ),
              footer: Container(
                height: 80,
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // leading: Text(name,style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text("Php $price"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationService {
    void selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
}
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification:  (String? payload) async {
      print("okayyyy");
      Get.toNamed('/transaction');
    });
  }

  Future<void> showNotification(int id, String title, String body, int seconds) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@drawable/ic_launcher'
        ),
        iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

}







