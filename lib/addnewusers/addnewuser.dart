import 'package:firebase_user_login/screensetprovider/screensetprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddUser extends StatefulWidget {
  // const AddUser({Key? key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  //variable declarations
  TextEditingController _name = new TextEditingController();
  TextEditingController _job = new TextEditingController();

  final _formKeyAddUser = GlobalKey<FormState>();


  //add new users
  addUser() async {
    print(_name.text);
    print(_job.text);
    setState(() {});
    final isValid = _formKeyAddUser.currentState.validate();
    print("valid :  ${isValid}");
    if (!isValid || _name.text == "") {
      _name.text.trim();
      _job.text.trim();
      if (_name.text == "") {
        final isValid = _formKeyAddUser.currentState.validate();
        if (!isValid || _name.text == "") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name is Invalid ')),
          );
          return;
        }
      }
      if (_job.text == "") {
        if (_job.text == "") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job is Invalid ')),
          );
          return;
        }
      }
    } else {
      var dt = {"name": _name.text.trim(), "job": _job.text.trim()};
      var params = json.encode(dt);
      var res = await http.post("https://reqres.in/api/users", body: params);

      setState(() {
        print(res.body);
        print(res.statusCode);
        if (res.statusCode == 201 || res.statusCode == 200) {
          setState(() {});
          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: Text(
              "New Employee Added Successfully",
              style: TextStyle(color: Colors.black),
            ),
          );

          // show the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // primary: false,
        centerTitle: true,
        title: Text(
          'Add Users',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(28.0),
            child: Form(
              key: _formKeyAddUser,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 26,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[200])),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[300])),
                        filled: true,
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.grey[100],
                        hintText: "Name"),
                    controller: _name,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                    validator: (value) {
                      print("value is ...${value}");
                      if (_job.text == "") {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[200])),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[300])),
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: "Job"),
                    controller: _job,
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
                      addUser();
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}
