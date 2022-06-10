import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:ordering_app/pages/config/global.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class ItemStatus extends StatefulWidget {
  dynamic args = Get.arguments;

  @override
  _ItemStatusState createState() => _ItemStatusState(this.args);
}

class _ItemStatusState extends State<ItemStatus> {

    TextEditingController _quantity = new TextEditingController();
    static String BASE_URL = '' + Global.url + '/carts/';
    void addToCart() async {
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var params = {
      "product_name": args[2],
      "quantity": _quantity.text,
      "user_id": _id,
      "product_id": args[1],
      "image": args[0],
    };
    final response = await http.post(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    final data = json.decode(response.body); 
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
  bool isLiked =false;
//  void initState() {
//    viewStatusLike();
//     // print('NDFAJEHWFIHJEDIFJAIJWEFOJAWEJFIJAODJFAWE');
//     getData();
    
//     // TODO: implement initState
//     super.initState();
//   }
  final args;
  _ItemStatusState(this.args);
  bool _load = false;
  List data = [];
 
  Future<String> getData() async {
    print('okay');
    setState(() {
      _load=true;
    });
    // final response = await http.get(
    //     Uri.parse(BASE_URL + '/' + '${args[1]}'),
    //     headers: {"Content-Type": "application/json"});
    setState(() {
      try {
        _load = false;
        // data = json.decode(response.body);
        print(data);
      } finally {
        _load = false;
      }
    });
    return "";
  }
// void addLike() async {
//     setState(() {
//       _load = true;
//     });
//     final prefs = await SharedPreferences.getInstance();
//     var _id = prefs.getInt("_id");
//     var params = {
//       "menu_id": args[1],
//       "user_id": _id,
//     };
//     final response = await http.post(Uri.parse(BASE_URL1 + '/' + '1'),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(params));
//     final data = json.decode(response.body);
//   }
  
  // void viewStatusLike() async {
  //   setState(() {
  //     _load = true;
  //   });
  //   final prefs = await SharedPreferences.getInstance();
  //   var _id = prefs.getInt("_id");
  //   var params = {
  //     "menu_id": args[1],
  //     "user_id": _id,
  //   };
  //   final response = await http.put(Uri.parse(BASE_URL1 + '/' + '1'),
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(params));
  //   final data = json.decode(response.body);
  //   isLiked = data;
  // } 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${args[2]}"),
          backgroundColor: Color(0xff222f3e),
        ),
        body: ListView(
          children: [
            Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  height: 200,
                  width: 400,
                  child: Image.network(args[0], fit: BoxFit.cover)),
                  // Positioned(child: IconButton(icon: Icon(Icons.favorite,size: 30,color: isLiked ? Colors.red : Colors.grey,),onPressed: (){
                  //   // addLike();
                  //    Get.toNamed('/home');
                  // },),top:10,right: 10,
                  // )
              ],),
              Padding(padding: EdgeInsets.only(bottom:10)),
              Container(
                height: 400,
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   Container(
                     padding:EdgeInsets.all(10),
                     child:  Column(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text("Php ${args[3]}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                      Text("Quantity : ${args[4]}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                      Text("Status :  ${args[5]}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                      Text("Total :  ${ int.parse(args[4])*double.parse(args[3])}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                      // Text("Stocks: ${args[4]}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0))
                  ],
                ),
                   ),
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   child:Row(
                  //   children: [
                  //      Text("Description:",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),  
                  //   ],
                  // ),
                  // ),
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   child: Row(
                  //   children: [
                  //      Column(
                    
                  //    children:[
                  //      Text(args[5],style:TextStyle(fontSize: 15.0))
                  //    ]
                  //  ),
                  //   ],
                  // ),
                  // ),
                  //  Container(
                  //         padding: EdgeInsets.all( 20),
                  //         child: Row(
                  //           mainAxisAlignment:MainAxisAlignment.center,
                  //           children: [
                  //             Container(
                  //         padding: EdgeInsets.only(top: 15),
                  //         width: 50,
                  //         child: ElevatedButton(
                  //           style: ButtonStyle(
                  //               backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                  //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //                   RoundedRectangleBorder(
                  //                       borderRadius: BorderRadius.circular(18.0),
                  //                       ))),
                  //           child: Text('+'),
                  //           onPressed: () {
                         
                  //           },
                  //         ),
                  //       ),
                  //             Container(
                  //               width: 150,
                  //               padding:EdgeInsets.only(right: 10,left:10),
                  //               child: TextField(
                  //           controller: _quantity,
                  //           decoration: InputDecoration(
                  //               contentPadding: EdgeInsets.all(8.0),enabledBorder: OutlineInputBorder(
                  //                     borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  //                      borderRadius: BorderRadius.circular(20.0),
                  //                 ),
                  //               border: OutlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                 color: Colors.purple, 
                  //                   width: 5.0),
                  //                 borderRadius: BorderRadius.circular(20.0),
                  //               ),
                  //               filled: true,
                  //               hintStyle: TextStyle(color: Colors.grey[800]),
                  //               hintText: "Quantity",
                  //               fillColor: Colors.white70),
                  //         ),
                  //             ),
                  //         Container(
                  //         padding: EdgeInsets.only(top: 15),
                  //         width: 50,
                  //         child: ElevatedButton(
                  //           style: ButtonStyle(
                  //               backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                  //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //                   RoundedRectangleBorder(
                  //                       borderRadius: BorderRadius.circular(18.0),
                  //                       ))),
                  //           child: Text('-'),
                  //           onPressed: () {
                  //             if(int.parse(_quantity.text)< 2 ){
                  //               return ;
                  //             }
                  //             setState(() {
                  //               _quantity.text = (int.parse(_quantity.text) - 1).toString();
                  //             });
                  //           }, 
                  //         ),
                  //       ),
                  //           ],
                  //         )
                  //       ),
                  //  Row(
                  //    mainAxisAlignment: MainAxisAlignment.center,
                  //    children: [
                  //       Container(
                  //         padding: EdgeInsets.all(15),
                  //         width: 150,
                  //         child: ElevatedButton(
                  //           style: ButtonStyle(
                  //               backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                  //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //                   RoundedRectangleBorder(
                  //                       borderRadius: BorderRadius.circular(18.0),
                  //                       ))),
                  //           child: Text('Add To Cart'),
                  //           onPressed: () {
                  //             addToCart();
                  //           },
                  //         ),
                  //       ),
                  //        Container(
                  //         padding: EdgeInsets.all(15),
                  //         width: 150,
                  //         child: ElevatedButton(
                  //           style: ButtonStyle(
                  //               backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                  //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //                   RoundedRectangleBorder(
                  //                       borderRadius: BorderRadius.circular(18.0),
                  //                       ))),
                  //           child: Text('Buy Now'),
                  //           onPressed: () {
                  //            Get.toNamed('/checkout',arguments:["${args[0]}","${args[1]}","${args[2]}","${args[3]}","${args[4]}","${args[5]}","${_quantity.text}","solo"]);
                  //           },
                  //         ),
                  //       ),
                  //    ],
                  //  )
                  ],
                )
              ),
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
            ],
          ),
        ),
          ],
        ),
     );
  }
}
