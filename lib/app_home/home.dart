import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_user_login/screensetprovider/screensetprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //variable declarations
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  List<dynamic> list = [];
  int page = 1;
  int totalPage=0;


  @override
  void initState() {
    setState(() {
      this._getMoreData(page);
    });

    super.initState();
    //scroll listener
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {


        if(totalPage >= page){
          _getMoreData(page);

        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All Pages Loaded')),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }


//build widget
  @override
  Widget build(BuildContext context) {

    //provider called
    final screenset = Provider.of<ScreenSetProvider>(context);
    return WillPopScope(
        onWillPop: ()async=> screenset.screenExit(context),
    child:Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "\t Employee Details",
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: _buildList(),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    )
    );
  }


//build body widget
  Widget _buildList() {
    return ListView.builder(
      itemCount: list.length + 1, // Add one more item for progress indicator
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == list.length) {
          return _buildProgressIndicator();
        } else {
          return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              // borderOnForeground: true,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 19),
              shadowColor: Colors.black,
              elevation: 2.0,
              // margin: EdgeInsets.only(bottom: 15.0),
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       CircleAvatar(
                         radius: 60.0,
                         backgroundImage:  NetworkImage(
                             list[index]['avatar'],
                             // fit: BoxFit.cover
                         ),

                       ),
                        Text("${list[index]['first_name']}   ${list[index]['last_name']}")
                      ],
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),

                        Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            children: [
                              SizedBox(
                                width: 13,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    list.forEach(print);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [

                                        Expanded(
                                            child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "${list[index]['email']}"
                                                ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        )),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),

                      ],
                    )),
                  ],
                ),
              ));

        }
      },
      controller: _sc,

    );
  }

  //get Data from api
  void _getMoreData(int index) async {
    if (!isLoading || totalPage == page-1) {
      setState(() {
        isLoading = true;
      });
      var res = await http.get(
          "https://reqres.in/api/users?page=${page}",

          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });
      print(res.body);
      print(res.statusCode);
      var r = json.decode(res.body);
      print(r['data']);
      totalPage = r['total_pages'];
      if( page <= r['total_pages'] ){
        List<dynamic> t = r['data'];
     for (int i = 0; i < t.length; i++) {
          list.add(t[i]);
        }

        setState(() {
          isLoading = false;
          // list.addAll(t);
          print("'$page th page'");
          page++;
        });
      }
      else{
        setState(() {
          isLoading = false;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All Pages Loaded')),
          );
        });

      }

    }
  }

  //Page load indicator
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
