import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobileappflutter/Animation/FadeAnimation.dart';
import 'package:mobileappflutter/View/signup.dart';
import 'dart:convert' show json, base64, ascii;
import 'dart:convert';
import 'env.dart';
import 'navbar.dart';

final storage = FlutterSecureStorage();

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return CircularProgressIndicator();
            if(snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.split(".");
              if(jwt.length !=3) {
                return LoginPage();
              } else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                  return Navbar(str, payload);
                } else {
                  return LoginPage();
                }
              }
            } else {
              return LoginPage();
            }
          }
      ),
    );
  }
}
class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  Future<String> attemptLogIn(String username, String password) async {
    final body = jsonEncode({"username": username,"password": password});
    Map<String,String> headers = {'Content-Type': 'application/json; charset=UTF-8'};
    var res = await http.post(
        "$SERVER_IP/login",
        headers: headers,
        body: body
    );

    if(res.statusCode == 200) {
      return res.headers["authorization"];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Color.fromRGBO(58, 66, 86, 1.0),
                  Color.fromRGBO(83, 94, 121, 1.0),
                  Color.fromRGBO(118, 131, 162, 1.0)
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1, Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),)),
                  SizedBox(height: 10,),
                  FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        FadeAnimation(1.4, Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(58, 66, 86, 0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextField(
                                  obscureText: true,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        SizedBox(height: 40,),
                        FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Colors.grey),)),
                        SizedBox(height: 40,),
                        FadeAnimation(1.6, RaisedButton(
                          textColor: Colors.white,
                          color: Color.fromRGBO(93, 113, 163, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 13),
                          child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          onPressed: () async {
                            var username = _usernameController.text;
                            var password = _passwordController.text;
                            var jwt = await attemptLogIn(username, password);
                            if(jwt != null) {
                              storage.write(key: "jwt", value: jwt);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Navbar.fromBase64(jwt)
                                  )
                              );
                            } else {
                              displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                            }
                          },
                        ),),
                        FadeAnimation(2, FlatButton(
                          child: Text("Create Account", style: TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => new SignupPage()
                            ));
                          },
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}