
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordering_app/pages/about/views.dart';
import 'package:ordering_app/pages/carts/views.dart';
import 'package:ordering_app/pages/chat/views.dart';
import 'package:ordering_app/pages/checkout/views.dart';
import 'package:ordering_app/pages/checkout_cart/views.dart';
import 'package:ordering_app/pages/details/views.dart';
import 'package:ordering_app/pages/item_details/views.dart';
import 'package:ordering_app/pages/most_buy/views.dart';
import 'package:ordering_app/pages/notifications/views.dart';
import 'package:ordering_app/pages/profile/views.dart';
import 'package:ordering_app/pages/recommended/views.dart';
import 'package:ordering_app/pages/reset_password/views.dart';
import 'package:ordering_app/pages/search/views.dart';
import 'package:ordering_app/pages/transaction/views.dart';
import 'package:ordering_app/pages/wishlist/views.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ordering_app/pages/home/views.dart';
import 'package:ordering_app/pages/register/views.dart';

import 'pages/login/views.dart';
void main() async{
 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter',
      theme: ThemeData(
      ),
      getPages: [
        GetPage(name: "/starting", page:()=>Login()),
        GetPage(name: "/register", page:()=>SignUp()),
        GetPage(name: "/home", page:()=>Home()),
        GetPage(name: "/details", page:()=>Details()),
        GetPage(name: "/cart", page:()=>Carts()),
        GetPage(name: "/chat", page:()=>ChatPage()),
        GetPage(name: "/transaction", page:()=>Transaction()),
        GetPage(name: "/checkout", page:()=>Checkout()),
       GetPage(name: "/item_status", page:()=>ItemStatus()),
       GetPage(name: "/notification", page:()=>Notifications()),
        GetPage(name: "/profile", page:()=>Profile()),
        GetPage(name: "/search", page:()=>Search()),
        GetPage(name: "/checkout_cart", page:()=>CheckoutCart()),
        GetPage(name: "/about", page:()=>About()),
       GetPage(name: "/reset_password", page:()=>ResetPassword()),
       GetPage(name: "/most_buy", page:()=>MostBuy()),
       GetPage(name: "/wishlist", page:()=>Wishlist()),
       GetPage(name: "/most_view", page:()=>MostView()),
        
        // GetPage(name: "/signup", page:()=>SignUp()),
        // GetPage(name: "/profile", page:()=>Profile()),
        // GetPage(name: "/resetPassword", page:()=>ResetPassword()),
        // GetPage(name: "/receiptList", page:()=>receiptList()),
        // GetPage(name: "/receipt", page:()=>receipt()),
        // GetPage(name: "/products", page:()=>Products()),
        // GetPage(name: "/cart", page:()=>Cart()),
        // GetPage(name: "/favorites", page:()=>Favorites()),
        // GetPage(name: "/product_details", page:()=>ProductDetails()),
      ],
      initialRoute: "/home"  ,
    );
  }
}
