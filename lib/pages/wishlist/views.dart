import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ordering_app/pages/config/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);
  @override
  _WishlistState createState() => _WishlistState();
}


class _WishlistState extends State<Wishlist> {
  void addToWishlist() async {
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var params = {
     "data":data
    };
    final response = await http.post(Uri.parse(Global.url+'/'+'Wishlist-add-bulk/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));

     AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: "Successfull Added !",
      desc: "",
      btnOkOnPress: () {
        Get.toNamed('/home');
      },
    )..show();
  }
   void notify(DialogType type , title, desc){
      AwesomeDialog(
                context: context,
                dialogType:type,
                animType: AnimType.BOTTOMSLIDE,
                title: title,
                desc: desc,
                btnOkOnPress: () {
                  addToWishlist();
                },
                btnCancelOnPress:(){

                }
                )..show();
    }

 static String BASE_URL = '' + Global.url + '/wishlist_user';
  List data = [];
  bool _load = false;
  Future<String> getData() async {
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    final response = await http.get(Uri.parse(BASE_URL + '/' + _id.toString()),
        headers: {"Content-Type": "application/json"});
  double total = 0.0;
    this.setState(() {
      try {
        _load = false;
        data = json.decode(response.body);
       for(int x=0;x<data.length;x++){
         setState(() {
           print(data);
           total = total + double.parse(data[x]['price']);
         });
       }
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children:[
            Text('Wishlist'),
            // Text('Total: ')
          ]
        ),
        backgroundColor: Color(0xff222f3e),
      ),
      body:  _load
                ? Container(
                    color: Colors.white10,
                    width: 70.0,
                    height: 70.0,
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Center(
                            child: const CircularProgressIndicator()))
                      ],
                    ),
                  )
                : Container(
        child: new ListView.separated(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: new ListTile(
                  onTap: (){
                          Get.toNamed('/details',arguments:["${data[index]['image']}","${data[index]['id']}","${data[index]['product_name']}","${data[index]['price']}","${data[index]['stocks']}","${data[index]['descriptions']}"]);
                        },
                  title: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                    Image.network(data[index]['image'],height:50.0),
                
                  ],),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                          Text("Name: ${data[index]['product_name']}"),
                    ],
                  ),
                ),
                );
              },separatorBuilder: (context, index) {
                  return Text('');
                },
            ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     var total = 0.0;
      //     for(int x=0;x<data.length;x++){
      //       total = total + double.parse(data[x]['price']);
      //     }
      //        notify(DialogType.INFO, 'Are you sure you want all to check this out?', "Total:${total}");
      //     // Add your onPressed code here!
      //   },
      //   backgroundColor: Color(0xff222f3e),
      //   child: const Icon(Icons.payment),
      // ),
    );
  } 

}









