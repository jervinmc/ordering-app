import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ordering_app/pages/checkout/views.dart';
import 'package:ordering_app/pages/config/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class Carts extends StatefulWidget {
  const Carts({Key? key}) : super(key: key);
  @override
  _CartsState createState() => _CartsState();
}

class _CartsState extends State<Carts> {
  List<bool> checklist = [];
  void addToTransaction() async {
    setState(() {
      _load = true;
    });
    var transactChecked = [];
    for(int x=0;x<data.length;x++){
      setState(() {
        if(checklist[x]){
          transactChecked.add(data[x]);
        }
        
      });
    }
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var params = {"data": transactChecked};
    final response = await http.post(
        Uri.parse(Global.url + '/' + 'transaction-add-bulk/'),
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
   void deleteCart(id) async {
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    final response = await http.delete(
        Uri.parse(Global.url + '/' + 'carts/${id}/'),
        headers: {"Content-Type": "application/json"},);
  getData();

  }

  void notify(DialogType type, title, desc) {
    AwesomeDialog(
        context: context,
        dialogType: type,
        animType: AnimType.BOTTOMSLIDE,
        title: title,
        desc: desc,
        btnOkOnPress: () {
          addToTransaction();
        },
        btnCancelOnPress: () {})
      ..show();
  }

  static String BASE_URL = '' + Global.url + '/cart_user';
  List data = [];
  bool _load = false;
  void paypalCheckout()async{
     var transactChecked = [];
    for(int x=0;x<data.length;x++){
      setState(() {
        if(checklist[x]){
          transactChecked.add(data[x]);
        }
        
      });
    }
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var params = {"data": transactChecked};
    final response123 = await http.post(
        Uri.parse(Global.url + '/' + 'transaction-add-bulk/'),
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
        for (int x = 0; x < data.length; x++) {
          setState(() {
            checklist.add(false);
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
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Carts'),
          // Text('Total: ')
        ]),
        backgroundColor: Color(0xff222f3e),
      ),
      body: _load
          ? Container(
              color: Colors.white10,
              width: 70.0,
              height: 70.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:
                          new Center(child: const CircularProgressIndicator()))
                ],
              ),
            )
          : Column(children: [
              Container(
                height: 500,
                child: new ListView.separated(
                  itemCount: data == null ? 0 : data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: new ListTile(
                        onTap: () {
                          // Get.toNamed('/details', arguments: [
                          //   '${data[index][2]}',
                          //   '${data[index][0]}',
                          //   '${data[index][1]}'
                          // ]);
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(data[index]['image'], height: 50.0),
                            Text("Name: ${data[index]['product_name']}"),
                            IconButton(onPressed: ()async{
                               AwesomeDialog(
                context: context,
                dialogType: DialogType.QUESTION,
                animType: AnimType.BOTTOMSLIDE,
                title: "Are you sure you want to delete this item?",
                desc: "",
                btnOkOnPress: () async{
                  final prefs = await SharedPreferences.getInstance();
                   
                     deleteCart(data[index]['id']);
                },
                btnCancelOnPress: (){

                }
              )..show();
                           
                            }, icon: Icon(Icons.delete,color:Colors.red))
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Text("Quantity: ${data[index]['quantity']}"),
                            Text(
                                "Subtotal: Php ${double.parse(data[index]['price'])} "),
                          Checkbox(value: checklist[index], onChanged:(val){
                            setState(() {
                              checklist[index] = val!;
                            });
                          
                    })]
                          ,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return  Text('');
                  },
                ),
              ),
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
                            child: Text('Proceed'),
                            onPressed: () {
                               var transactChecked = [];
                            for(int x=0;x<data.length;x++){
                              setState(() {
                                if(checklist[x]){
                                  transactChecked.add(data[x]);
                                }
                                
                              });
                            }
                              Get.toNamed('/checkout_cart',arguments:[transactChecked]);
                            //  addToTransaction();
                            },
                          ),
                        ),
                        //  Container(
                        //   padding: EdgeInsets.all(15),
                        //   width: 350,
                        //   child: ElevatedButton(
                        //     style: ButtonStyle(
                        //         backgroundColor: MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                        //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //             RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(18.0),
                        //                 ))),
                        //     child: Text('Paypal'),
                        //     onPressed: () {
                        //         paypalCheckout();
                        //     },
                        //   ),
                        // ),
                  ],
                ),
                   ), 
                  ],
                )
              ),
            ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     var total = 0.0;
      //     for (int x = 0; x < data.length; x++) {
      //       total = total + double.parse(data[x]['price']);
      //     }
      //     //  notify(DialogType.INFO, 'Are you sure you want all to check this out?', "Total:${total}");
      //     // Add your onPressed code here!
      //   },
      //   backgroundColor: Color(0xff222f3e),
      //   child: const Icon(Icons.payment),
      // ),
    );
  }
}
