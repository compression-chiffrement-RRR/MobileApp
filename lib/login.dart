import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  Future<int> attemptSignUp(String username, String password) async {
    var res = await http.post(
        '$SERVER_IP/signup',
        body: {
          "username": username,
          "password": password
        }
    );
    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Connexion'),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                height: 200.0,
                width: 200.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                          "https://zupimages.net/up/20/22/uybm.jpg")),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.black,
                    focusColor: Colors.black,
                    hoverColor: Colors.black,
                    labelText: 'Identifiant',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mot de passe',
                  ),
                ),
              ),
              Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.black,
                    child: Text('Me connecter'),
                    onPressed: () async {
                      var username = _usernameController.text;
                      var password = _passwordController.text;
                      var jwt = await attemptLogIn(username, password);
                      if(jwt != null) {
                        storage.write(key: "jwt", value: jwt);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Navbar.fromBase64(jwt)
                            )
                        );
                      } else {
                        displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                      }
                    },
                  )),
              FlatButton(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;

                    if(username.length < 4)
                      displayDialog(context, "Invalid Username", "The username should be at least 4 characters long");
                    else if(password.length < 4)
                      displayDialog(context, "Invalid Password", "The password should be at least 4 characters long");
                    else{
                      var res = await attemptSignUp(username, password);
                      if(res == 201)
                        displayDialog(context, "Success", "The user was created. Log in now.");
                      else if(res == 409)
                        displayDialog(context, "That username is already registered", "Please try to sign up using another username or log in if you already have an account.");
                      else {
                        displayDialog(context, "Error", "An unknown error occurred.");
                      }
                    }
                  },
                  child: Text("Je m\'enregistre")
              ),
              FlatButton(
                padding: EdgeInsets.fromLTRB(10, 90, 10, 0),
                onPressed: (){
                  //forgot password screen
                },
                textColor: Colors.black,
                child: Text('Mot de passe oublier'),
              ),
            ],
          ),
        )
    );
  }
}