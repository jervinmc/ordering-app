import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({ Key? key }) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('About us'),
        
          // Text('Total: ')
        ]),
        backgroundColor: Color(0xff222f3e),
      ),
      body: ListView(
        children: [
          Container(
            height: 1200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
             Center(
               child:  Image.asset("assets/logo_e.png",height: 200,),
               
             ),
              Container(
                padding:EdgeInsets.all(20),
                child:Column(
                  children: [
                    new Text("2E Glass Palace is the first given name to the business that owns by Elias Ote and Sahrani."),
                    Text("The business was built since 2013. The E&E Glass and Aluminum Works "),
                     Text("is a glass business located in East Basak Malutlut Marawi City.The business operates in 8 am to 6pm weekends and weekdays Monday to Thursday"),
                      Text("Since the business is located at Muslim Region, Friday is non-working for them to pray in masjid."),

                  ],
                )),
              Text("Email: eandeglassaluminum@gmail.com"),
              Divider(),
              Text("Contact No. "),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                       Text("Smart:  0946-132-2930"),
                  Text("0946-132-2930 "),
                   Text("0907-161-8858 "),
                    Text("0968-350-3000 "),
                    ],
                  ),
                  Column(
                    children: [
                       Text("Globe:  0946-132-2930"),
                  Text("0946-132-2930 "),
                   Text("0907-161-8858 "),
                    Text("0968-350-3000 "),
                    ],
                  )
                ],
              ),
              ),

              Container( 
                padding: EdgeInsets.all(20),
                child:  Text("Business Permit & Sanitary Permit to Operate",style: TextStyle(fontSize: 20.0),),),
              Center(
               child:  Image.asset("assets/permit1.jpg",height: 200,),
               
             ),
             Center(
               child:  Image.asset("assets/permit2.jpg",height: 200,),
               
             ),
          ]
        ),
      )
        ],
      )
     
    );
  }
}