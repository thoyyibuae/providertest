import 'package:firebase_user_login/addnewusers/addnewuser.dart';
import 'package:firebase_user_login/screensetprovider/screensetprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../app_home/home.dart';
import 'dart:async';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variable declarations;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  final _formKeyLoginUser = GlobalKey<FormState>();

  //user login
  userLogin() async {
    print(_email.text);

    print(_password.text);
    final isValid = _formKeyLoginUser.currentState.validate();
    if (!isValid) {
      _email.text.trim();
      _password.text.trim();
      if (_email.text == "") {
        final isValid = _formKeyLoginUser.currentState.validate();
        if (!isValid || _email.text == "") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email is Invalid ')),
          );
          return;
        }
      }
      if (_password.text == "") {
        // final isValid = _formKeyLoginUser.currentState.validate();
        if (_password.text == "") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password is Invalid ')),
          );
          return;
        }
      }
    } else {
      _email.text.trim();
      _password.text.trim();
      var dt = {"email": _email.text, "password": _password.text};
      var params = json.encode(dt);
      var res = await http
          .post("https://reqres.in/api/login", body: params, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      print(res.body);
      setState(() {
        print(res.body);
        print(res.statusCode);
        print('email :${_email}');
        print('password :${_password}');
        if (res.statusCode == 200) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      // getuser();
    });
    super.initState();
  }

  //validate email
  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }


  //buiild widget
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final screenset = Provider.of<ScreenSetProvider>(context);
    return WillPopScope(
      onWillPop: () async => screenset.screenExit(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          // primary: false,
          centerTitle: true,
          title: Text(
            'Email Register And Login',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(28.0),
              child: Form(
                key: _formKeyLoginUser,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 26,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) => validateEmail(value),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[200])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          filled: true,
                          labelStyle: TextStyle(color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.grey[100],
                          hintText: "Email"),
                      controller: _email,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      obscureText: true,
                      validator: (value) {
                        print("value is ...${value}");
                        if (_password.text == "") {
                          return 'Please enter Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[200])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelStyle: TextStyle(color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: "Password"),
                      controller: _password,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        userLogin();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            SizedBox(
              height:20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                FlatButton.icon(
                  icon: Icon(Icons.add),
                    label:Text("Add New User",
                      style: TextStyle(

                          color: Colors.black
                      ),) ,
                    // color:Colors.blue ,
                    onPressed: (){
                      // userLogin();
                      setState(() {
                        Navigator.push((context), MaterialPageRoute(builder: (context)=>AddUser()));
                      });
                    }, ),
                SizedBox(
                  width:20,
                )

              ],
            ),

          ],
        ),
      ),
    );
  }
}
