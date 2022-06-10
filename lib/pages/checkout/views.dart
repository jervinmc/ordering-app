

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:ordering_app/pages/config/global.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
class Checkout extends StatefulWidget {
  dynamic args = Get.arguments;

  @override
  _CheckoutState createState() => _CheckoutState(this.args);
}

class _CheckoutState extends State<Checkout> {
  void checkOut()async {
    final prefs = await SharedPreferences.getInstance();
        DateTime now = DateTime.now();
String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var _id = prefs.getInt("_id");
    var _number = prefs.getString("_number");
   var params = {
     "quantity":args[6],
     "product_name":args[2],
     "image":args[0],
     "price":double.parse(args[3]),
     "user_id":_id,
     "fullname":"${firstname} ${lastname}",
     "address":"${barangay} ${city}",
     "users_profile":"${image_profile}",
     "user_id":_id,
     "date":formattedDate,
    "color":args[9],
    "contact_number":_number,
     "size":args[8],
     "status":"Pending",
     "subtotal":double.parse(args[3])*int.parse(args[6])+double.parse(args[3])*int.parse(args[6])*0.10,
     "product_id":args[1],
   };
     final response = await http.post(Uri.parse(Global.url+'/'+'transaction/'),
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
  void paypalCheckout()async{
            DateTime now = DateTime.now();
String formattedDate = DateFormat('yyyy-MM-dd').format(now);
     final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
   var params = {
     "quantity":args[6],
     "product_name":args[2],
     "image":args[0],
     "price":args[3],
     "color":args[9],
     "size":args[8],
     "date":formattedDate,
     "fullname":"${firstname} ${lastname}",
     "address":"${barangay} ${city}",
     "users_profile":"${image_profile}",
     "user_id":_id,
     "status":"Pending",
     "subtotal":double.parse(args[3])*int.parse(args[6]),
     "product_id":args[1]
   };
     final response123 = await http.post(Uri.parse(Global.url+'/'+'transaction/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
String username = "AfhkPCUFnmyofuwN3OSicO7Z83gKoXlDUmba7meh3GewvB6eC1nQ74JrMCSANpYyUudyjEvZBoda-5q-";
String password = "EFmDE0yWqqoyTN6LuLgF7Wn0j2iZGq8gSkSOGzaNlfHKZy2upl2FkbriFlgk55_SGmFSvIVgmVf9cXdk";
var bytes = utf8.encode("$username:$password");
var credentials = base64.encode(bytes);
Map token = {
'grant_type': 'client_credentials'
};

 
 var headers = {
 "Accept": "application/json",
 'Accept-Language': 'en_US',
 "Authorization": "Basic $credentials"
  };

 var url = "https://api.sandbox.paypal.com/v1/oauth2/token";
 var requestBody = token;
 http.Response response = await http.post(Uri.parse(url), body: requestBody, headers: headers);
 var responseJson = json.decode(response.body);
 print(responseJson['access_token']);
    var params1 = {
  "intent": "sale",
  "payer": {
    "payment_method": "paypal"
  },
  "transactions": [{
    "amount": {
      "total": "25.00",
      "currency": "USD",
      "details": {
        "subtotal": "25.00"
      }
    },
    "description": "This is the payment transaction description.",
    "custom": "EBAY_EMS_90048630024435",
    "invoice_number": "48787582672",
    "payment_options": {
      "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
    },
    "soft_descriptor": "ECHI5786786",
    "item_list": {
      "items": [{
        "name": "handbag",
        "description": "Black color hand bag",
        "quantity": "1",
        "price": "25",
        "sku": "product34",
        "currency": "USD"
      }],
      "shipping_address": {
        "recipient_name": "Hello World",
        "line1": "4thFloor",
        "line2": "unit#34",
        "city": "SAn Jose",
        "country_code": "US",
        "postal_code": "95131",
        "phone": "011862212345678",
        "state": "CA"
      }
    }
  }],
  "note_to_payer": "Contact us for any questions on your order.",
  "redirect_urls": {
    "return_url": "http://10.0.2.2:8000/api/v1",
    "cancel_url": "https://example.com"
  }
};
url = "https://api-m.sandbox.paypal.com/v1/payments/payment";
 var headers_payment = {
 "Accept": "application/json",
 'Accept-Language': 'en_US',
 "Authorization": "Bearer ${responseJson['access_token']}",
 "Content-Type": "application/json"
  };
  http.Response response_payment = await http.post(Uri.parse(url), body: json.encode(params1), headers: headers_payment);
 var responseJson_payment = json.decode(response_payment.body);
 print(responseJson_payment['links'][1]['href']);
    // if (await canLaunch(responseJson_payment['links'][1]['href']))
    //   await launch(responseJson_payment['links'][1]['href']);
    // else 
    //   // can't launch url, there is some error
    //   throw "Could not launch $responseJson_payment['links'][1]['href']";
  

  // launchURL(responseJson_payment['links'][1]['href']);
    if (await canLaunch(responseJson_payment['links'][1]['href'])) {
      await launch(responseJson_payment['links'][1]['href']);
    } else {
      throw 'Could not launch $url';
    }
// http.Response response_checkout = await http.post(Uri.parse(url), body: requestBody, headers: headers_payment);
//  var responseJson_checkout = json.decode(response_checkout.body);

 return responseJson;




  }
 
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
 void initState() {
    // print('NDFAJEHWFIHJEDIFJAIJWEFOJAWEJFIJAODJFAWE');
    getData();
    
    // TODO: implement initState
    super.initState();
  }
  final args;
  _CheckoutState(this.args);
  bool _load = false;
  List data = [];
 
  String address = '';
  String firstname = '';
  String lastname = '';
  String image = '';
  String barangay = '';
  String city = '';
  String image_profile = '';
  Future<String> getData() async {
    print("okayyyy");
       final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
      // address = prefs.getString("_address")!;
     
      firstname = prefs.getString("_firstname")!;
      lastname = prefs.getString("_lastname")!;
      barangay = prefs.getString("_barangay")!;
      city = prefs.getString("_city")!;
      image_profile = prefs.getString("_image")!;
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
                height: 300,
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
              
                  children: [
                   Container(
                     padding:EdgeInsets.all(2),
                     child:  Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                      Text("Personal Information :",style:TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0)),
                      Text("Full Name : ${firstname} ${lastname}",style:TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0)),
                      Text("Address : ${barangay}, ${city}",style:TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0)),
                      Divider(),
                      Text("Price : Php ${args[3]}",style:TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0)),
                      Text("Quantity: ${args[6]}",style:TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0)),
                      Text("Shipping fee: Php ${double.parse(args[3])*int.parse(args[6])*0.10}",style:TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0)),
                      Text("Subtotal: Php ${double.parse(args[3])*int.parse(args[6])+(double.parse(args[3])*int.parse(args[6])*.10)}",style:TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0)),
                        Container(
                          padding: EdgeInsets.all(15),
                          width: 350,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ))),
                            child: Text('Cash on Delivery'),
                            onPressed: () {
                             checkOut();
                            },
                          ),
                        ),
                         Container(
                          padding: EdgeInsets.all(15),
                          width: 350,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ))),
                            child: Text('Paypal'),
                            onPressed: () {
                                paypalCheckout();
                            },
                          ),
                        ),
                  ],
                ),
                   ), 
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
