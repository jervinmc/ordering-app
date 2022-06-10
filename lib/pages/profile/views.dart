import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ordering_app/pages/config/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io' as io;
class Profile extends StatefulWidget {
 

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
        late  io.File selectedImage;
  static String BASE_URL = '' + Global.url + '/users';
  bool _load = false;
  int _id = 0;
  TextEditingController _email = new TextEditingController();
   TextEditingController _firstname = new TextEditingController();
    TextEditingController _lastname = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _age = new TextEditingController();
  TextEditingController _barangay = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _province = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  TextEditingController _repassword = new TextEditingController();
bool getImage = false;
  void notify(DialogType type, title, desc) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: desc,
      btnOkOnPress: (){
        setState(() async {
          _load=false;
          final prefs = await SharedPreferences.getInstance();
             prefs.setBool('isLoggedIn', false);
                  Navigator.pop(context);
          Get.toNamed('/starting');
        });
      },
    )..show();
  }
  void SignUp() async {
     
    if(_email.text==null || _password.text==null || _email.text=='' || _password.text=='') {
        notify(DialogType.ERROR,'Field is required.','Please fill up the form.');
        
        return;
    }
    if(_password.text.length<9){
      notify(DialogType.ERROR,'Password must be at least 8 characters.','');
      return ;
    }
    if(_repassword.text!=_password.text){
         notify(DialogType.ERROR,'Password does not match','');
      return;
    }
      final prefs = await SharedPreferences.getInstance();
    setState(() {
        _load=true;
      });
      var params = {
        "firstname":_firstname.text,
        "lastname":_lastname.text,
        "email":_email.text,
        "password":_password.text,
        "barangay":_barangay.text,
        "city":_city.text,
        "province":_province.text,
        "number":_number.text,
        "age":_age.text,
        "status":"Deactivated",
        "password":_password.text,
        "account_type":'Client',

      };
       final request = http.MultipartRequest(
        "PUT", Uri.parse(BASE_URL));
    final headers = {"Content-type": "multipart/form-data"};
    request.fields['firstname'] = _firstname.text;
    request.fields['users_id'] =prefs.getInt('_id')!.toString();
    request.fields['lastname'] = _lastname.text;
    request.fields['email'] = _email.text;
    request.fields['password'] = _password.text;
    request.fields['barangay'] = _barangay.text;
    request.fields['city'] =_city.text;
    request.fields['province'] = _province.text;
    request.fields['number'] =_number.text;
     request.fields['account_type'] ="Client";
          request.fields['age'] =_age.text;


    request.files.add(http.MultipartFile('image',
        selectedImage.readAsBytes().asStream(), selectedImage.lengthSync(),
        filename: selectedImage.path.split("/").last));
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
      setState(() {
        _load=true;
      });
      // final response = await http.post(Uri.parse(BASE_URL),headers: {"Content-Type": "application/json"},body:json.encode(params));
  
      
  }
   void runFilePiker() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
        print("not okay");

    if (pickedFile != null) {
      setState(() {
        getImage = true;
      });
       selectedImage = io.File(pickedFile.path);
      url = pickedFile.path;
      print("okay");
      setState(() {
          print(url);
      });
    }
  }
  void Save() async {
    if (_email.text == '' || _email.text == null) {
      notify(DialogType.ERROR, 'Required Field', 'Please fill up the form.');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    var params = {
      "email": _email.text,
      "password": _password.text,
      "id": prefs.getInt('_id')
    };
       final request = http.MultipartRequest(
        "PATCH", Uri.parse(BASE_URL+'/${prefs.getInt('_id')}/'));
    final headers = {"Content-type": "multipart/form-data"};
    request.fields['firstname'] = _firstname.text;
    request.fields['lastname'] = _lastname.text;
    request.fields['email'] = _email.text;
    if(_password.text!=''){
      request.fields['password'] = _password.text;
    }
    request.fields['barangay'] = _barangay.text;
    request.fields['city'] =_city.text;
    request.fields['province'] = _province.text;
    request.fields['number'] =_number.text;
     request.fields['status'] ="Deactivated";
     request.fields['account_type'] ="Client";
      request.fields['age'] =_age.text;
    setState(() {
      _load = true;
    });

    if(getImage){
      print("okayyy");
        request.files.add(http.MultipartFile('image',
        selectedImage.readAsBytes().asStream(), selectedImage.lengthSync(),
        filename: selectedImage.path.split("/").last));
    }

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
      setState(() {
        _load=true;
      });
    // String jsonsDnotifyataString = response.body.toString();
    // final _data = jsonDecode(jsonsDataString);
      notify(DialogType.SUCCES, 'Successfully Saved', 'Please login again for your new details. Thank you!');
    
  }

  void getPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email.text = prefs.getString("_email")!;
      _firstname.text = prefs.getString("_firstname")!;
      _lastname.text = prefs.getString("_lastname")!;
      _number.text = prefs.getString("_number")!;
      _age.text = prefs.getString("_age")!;
      _barangay.text = prefs.getString("_barangay")!;
      _province.text = prefs.getString("_province")!;
      _city.text = prefs.getString("_city")!;
      _id = prefs.getInt("_id")!;
      print(_email);
    });
  }

  void initState() {
    getPref();
  }
 String url = '';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
           backgroundColor:Color(0xff222f3e),
        ),
        body: ListView(
          children:[
            Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset("assets/images/mainlogo.png",height: 90,),
              Text('Profile'),
                        Image.file(io.File(url)),
                        new SizedBox(
                          width: 350.0,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () {
                              runFilePiker();
                              //  uploadImage();
                            },
                            child: Text('Upload Image'),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff222f3e),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                          )),
              Container(
                          padding: EdgeInsets.only(top: 20),
                          child: TextField(
                            controller: _email,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Email",
                                fillColor: Colors.white70),
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _firstname,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "First Name",
                                fillColor: Colors.white70),
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _lastname,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Last Name",
                                fillColor: Colors.white70),
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Phone Number",
                                fillColor: Colors.white70),
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _age,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Age",
                                fillColor: Colors.white70),
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _barangay,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Barangay",
                                fillColor: Colors.white70),
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _province,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Province",
                                fillColor: Colors.white70),
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _city,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "City",
                                fillColor: Colors.white70),
                          )
                        ),

                        Container(
                          height: 100,
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                                    obscureText: true,
                                    controller: _password,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        filled: true,
                                        hintStyle: TextStyle(color: Colors.grey[800]),
                                        hintText: "Password",
                                        fillColor: Colors.white70),
                                  )
                        ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  width: 250,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff222f3e),),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    child: Text('Save'),
                    onPressed: () {
                      Save();
                    },
                  ),
                ),
              ),
              _load
                  ? Center(
                      child: Container(
                      color: Colors.white10,
                      width: 70.0,
                      height: 70.0,
                      child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Center(
                              child: new CircularProgressIndicator())),
                    ))
                  : Text('')
            ],
          ),
        )
          ]
        ));
  }
}
