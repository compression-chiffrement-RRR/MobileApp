import 'package:flutter/material.dart';
import 'package:mobileappflutter/animation/FadeAnimation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'env.dart';

class SignupPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username, _email, _password;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  Future<bool> attemptSignUp(String username, String email, String password) async {
    final body = jsonEncode({
      "username": username,
      "email": email,
      "password": password
    });
    Map<String,String> headers = {'Content-Type': 'application/json; charset=UTF-8'};
    var res = await http.post(
        '$SERVER_IP/api/account',
        body: body,
        headers: headers
    );
    if(res.statusCode == 201)
      return true;
    return false;
  }

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 80,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(1, Text("Sign up", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),)),
                  SizedBox(height: 20,),
                  FadeAnimation(1.2, Text("Create an account, It's free", style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700]
                  ),)),
                ],
              ),
              Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(1.2, makeInput(
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            label: "Username",
                            validator: (val) => val.length < 4 ? 'Username required' : null,
                            onSaved: (val) => _username = val
                        )),
                        FadeAnimation(1.3, makeInput(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            label: "Email",
                            validator: (val) {
                              if(val.isEmpty)
                                return "Email required";
                              if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val))
                                return "Email not valid";
                              return null;
                            },
                            onSaved: (val) => _email = val
                        )),
                        FadeAnimation(1.4, makeInput(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            label: "Password",
                            obscureText: true,
                            validator: (val){
                              if(val.isEmpty)
                                return 'Password required';
                              return null;
                            },
                            onSaved: (val) => _password = val
                        )),
                        FadeAnimation(1.5, makeInput(
                            controller: _passwordConfirmController,
                            keyboardType: TextInputType.visiblePassword,
                            label: "Confirm Password",
                            obscureText: true,
                            validator: (val){
                              if(val.isEmpty)
                                return 'Confirm password required';
                              if(val != _passwordController.text)
                                return 'Both password not match';
                              return null;
                            }
                        )),
                      ],
                    ),
                  )
                ],
              ),
              FadeAnimation(1.6, RaisedButton(
                textColor: Colors.white,
                color: Color.fromRGBO(93, 113, 163, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(horizontal: 130, vertical: 15),
                child: Text("Sign up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    final snackbar = SnackBar(
                      duration: Duration(seconds: 10),
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Text("  Signing Up...")
                        ],
                      ),
                    );
                    _scaffoldKey.currentState.showSnackBar(snackbar);
                    attemptSignUp(_username, _email, _password).then((result) async {
                      if (result) {
                        final snackbar = SnackBar(
                          duration: Duration(seconds: 30),
                          content: Row(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Text("  Signing Up...")
                            ],
                          ),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackbar);

                        await Future.delayed(Duration(seconds: 1));
                        _scaffoldKey.currentState.hideCurrentSnackBar();
                        Navigator.pop(context, true);
                      } else {
                        _scaffoldKey.currentState.hideCurrentSnackBar();
                        displayDialog(context, 'Info', "Could not create your account, please retry");
                        _passwordController.clear();
                        _passwordConfirmController.clear();
                      }
                    });
                  }
                },
              ),),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({controller, keyboardType, validator, onSaved, label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          autocorrect: false,
          keyboardType: keyboardType,
          validator: validator,
          autovalidate: true,
          onSaved: onSaved,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 12,),
      ],
    );
  }
}