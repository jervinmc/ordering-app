import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:ordering_app/pages/config/global.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class Details extends StatefulWidget {
  dynamic args = Get.arguments;

  @override
  _DetailsState createState() => _DetailsState(this.args);
}

class _DetailsState extends State<Details> {

    TextEditingController _quantity = new TextEditingController();
    static String BASE_URL = '' + Global.url + '/carts/';
    static String BASE_URL_WISHLIST = '' + Global.url + '/wishlist/';
    static String BASE_URL_SIMILAR = '' + Global.url + '/product';
     static String BASE_URL_COLOR = '' + Global.url + '/color_product';
     static String BASE_URL_SIZE = '' + Global.url + '/size_product';
    List size_list = [];
    List similar_data = [];
    List color_list = [];
      String category_select = 'standard';
      String size_select = 'standard';
      final items_size = ['standard'];
      final items = ['standard'];
      String orig_price ='';
        Future<String> getData1() async {
    _load = true;
  
    setState(() {
      
    });
    final response = await http.get(
        Uri.parse(BASE_URL_SIMILAR+'?search=${args[2].split(' ')[0]}'),
        headers: {"Content-Type": "application/json"});
        String jsonsDataString = response.body.toString();
      final _data = jsonDecode(jsonsDataString);
      similar_data = _data;
        setState(() {
            try {
               similar_data = _data;
          
            } finally {
              _load = false;
            }
          });
    return "";
  }
  
    void addToWishlist() async {
      if(_quantity.text==''){
        
        return;
      }
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
      "size": size_select,
      "price": double.parse(args[3]) * int.parse(_quantity.text),
      "color": category_select,
      "image": args[0],
    };
    final response = await http.post(Uri.parse(BASE_URL_WISHLIST),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    // final data = json.decode(response.body); 
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
    void addToCart() async {
      if(_quantity.text==''){
        
        return;
      }
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
      "size": size_select,
      "price": double.parse(args[3]) * int.parse(_quantity.text),
      "color": category_select,
      "image": args[0],
    };
    final response = await http.post(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    // final data = json.decode(response.body); 
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
 void initState() {
   setState(() {
      _quantity.text='1';
   });
    // print('NDFAJEHWFIHJEDIFJAIJWEFOJAWEJFIJAODJFAWE');
    getData();
     getData1();
    // TODO: implement initState
    super.initState();
  }
  final args;
  _DetailsState(this.args);
  bool _load = false;
  List data = [];
 
  Future<String> getData() async {
    orig_price = args[3];
    print('okay');
    // setState(() {
    //   _load=true;
     
    // });
    final response = await http.get(
        Uri.parse(BASE_URL_COLOR + '/' + '${args[1]}/'),
        headers: {"Content-Type": "application/json"});
            String jsonsDataString = response.body.toString();
      final _data = jsonDecode(jsonsDataString);
      color_list = _data;
      print(_data);
      for(int x=0;x<_data.length;x++){
        setState(() {
          items.add(_data[x]['label']);
        });
      }
      final response1 = await http.get(
        Uri.parse(BASE_URL_SIZE + '/' + '${args[1]}/'),
        headers: {"Content-Type": "application/json"});
            String jsonsDataString1 = response1.body.toString();
      final _data1 = jsonDecode(jsonsDataString1);
      print(_data);
      for(int x=0;x<_data1.length;x++){
        setState(() {
          items_size.add(_data1[x]['label']);
        });
      }
      size_list = _data1;
      setState(() {
        
      });
    // setState(() {
    //   try {
    //     _load = false;
    //     // data = json.decode(response.body);
    //     print(data);
    //   } finally {
    //     _load = false;
    //   }
    // });
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
                height: 600,
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   Container(
                     padding:EdgeInsets.all(10),
                     child:  Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text("Php ${args[3]}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                      Text("Stocks: ${args[4]}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0))
                  ],
                ),
                   ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child:Row(
                    children: [
                       Text("Description:",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),  
                    ],
                  ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                    children: [
                       Column(
                    
                     children:[
                       Text(args[5],style:TextStyle(fontSize: 15.0))
                     ]
                   ),
                    ],
                  ),
                  ),
                   Text('Size :',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                   Container(
                 width: 350,
                        decoration:BoxDecoration(borderRadius:BorderRadius.circular(5),border:Border.all(color: Colors.black,width:1)),
                      padding: EdgeInsets.only(top: 10),
                      child:DropdownButton<String>(items: items_size.map(buildMenuItem).toList(),
                      value:size_select,
                      onChanged:(size_select)=>setState(() {
                        print(size_select);
                          for(int x=0;x<size_list.length;x++){
                            print(size_list[x]['label']);
                            if(size_list[x]['label']==size_select){
                              args[3] = size_list[x]['price'];
                              print(size_list[x]['price']);
                              setState(() {
                                
                              });
                            }
                            else if(size_select=='standard'){
                              args[3] = orig_price;
                              setState(() {
                                
                              });
                            }
                          }
                          this.size_select = size_select!;
                      }))
                    ),
                   Text('Color :',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
                   Container(
                 width: 350,
                        decoration:BoxDecoration(borderRadius:BorderRadius.circular(5),border:Border.all(color: Colors.black,width:1)),
                      padding: EdgeInsets.only(top: 10),
                      child:DropdownButton<String>(items: items.map(buildMenuItem).toList(),
                      value:category_select,
                      onChanged:(category_select)=>setState(() {
                          this.category_select = category_select!;
                      }))
                    ),
                   Container(
                          padding: EdgeInsets.all( 20),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              Container(
                          padding: EdgeInsets.only(top: 15),
                          width: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ))),
                            child: Text('-'),
                            onPressed: () {
                              if(int.parse(_quantity.text)< 2 ){
                                return ;
                              }
                              setState(() {
                                _quantity.text = (int.parse(_quantity.text) - 1).toString();
                              });
                            }, 
                          ),
                        ),
                              Container(
                                width: 150,
                                padding:EdgeInsets.only(right: 10,left:10),
                                child: TextField(
                            controller: _quantity,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8.0),enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                                       borderRadius: BorderRadius.circular(20.0),
                                  ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                  color: Colors.purple, 
                                    width: 5.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Quantity",
                                fillColor: Colors.white70),
                          ),
                              ),
                         
                         Container(
                          padding: EdgeInsets.only(top: 15),
                          width: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ))),
                            child: Text('+'),
                            onPressed: () {
                            
                              setState(() {
                                _quantity.text = (int.parse(_quantity.text) + 1).toString();
                              });
                            },
                          ),
                        ),
                            ],
                          )
                        ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ))),
                            child: Text('Add To Cart'),
                            onPressed: () {
                              if(int.parse(_quantity.text) > int.parse(args[4])){
                                return;
                              }
                               if(_quantity.text==''){
                                return;
                              }
                              addToCart();
                            },
                          ),
                        ),
                         Container(
                          padding: EdgeInsets.all(15),
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ))),
                            child: Text('Buy Now'),
                            onPressed: () {
                              if(_quantity.text==''){
                                return;
                              }
                              if(int.parse(_quantity.text) > int.parse(args[4])){
                                return;
                              }
                             Get.toNamed('/checkout',arguments:["${args[0]}","${args[1]}","${args[2]}","${args[3]}","${args[4]}","${args[5]}","${_quantity.text}","solo","${size_select}","${category_select}"]);
                            },
                          ),
                        ),
                     ],
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children:[
                      args[4]=='0' ? Container(
                          padding: EdgeInsets.all(15),
                          width: 200,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ))),
                            child: Text('Add to Wishlist'),
                            onPressed: () {
                              addToWishlist();
                            },
                          ),
                        ) : Text(''),
                     ]
                   )
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

             Row(
               children: [
                    Text('Similar Products',style: TextStyle(fontSize: 20.0,fontWeight:FontWeight.bold)),
               ],
             ),
            Container(
              height:200,
              child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                  itemCount:similar_data.length, 
                  itemBuilder: (BuildContext context, index){
                  return args[2]!=similar_data[index]['product_name'] ? Column(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                         Get.toNamed('/details',arguments:["${similar_data[index]['image']}","${similar_data[index]['id']}","${similar_data[index]['product_name']}","${similar_data[index]['price']}","${similar_data[index]['stocks']}","${similar_data[index]['descriptions']}"]);
                      },
                      child: Card(
                        elevation: 4,
                        // color: Color(0xffc6782b),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.all(20.0),
                        child: Container(
                          // width: 150,
                          // height: 185,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(similar_data[index]['image'].toString(),fit: BoxFit.cover,height:100,width: 100,),
                              
                              Padding(padding: EdgeInsets.only(bottom: 15))
                            ],
                          ),
                        )),
                    
                    ),
                    Column(
                      children: [
                        Text("${similar_data[index]['product_name']}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0)),
                              Text("",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )),
                      ],
                    ),
                        
                    
                  ],
                ) : Text('');
                }),
            )
            ],
          ),
        ),
          ],
        ),
     );
  }
   DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value:item,
    child: Container(padding:EdgeInsets.all(10),child:Text(item,style:TextStyle(fontSize: 15)))
  );
}
