import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _email;
  var email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              right: 10,
              left: 10,
              top: 10,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'Add Profile Picture and your Personal Details',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  //======================================================================================== Circle Avatar
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png'),
                              radius: 50.0,
                            ),
                            InkWell(
                              onTap: null,
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),
                                      color: Colors.black),
                                  margin: EdgeInsets.only(left: 70, top: 70),
                                  child: Icon(
                                    Icons.photo_camera,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                        Text('Half Body',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
//=========================================================================================== Form
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 100),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: email,
                            onChanged: ((String name) {
                              setState(() {
                                _email = name;
                                print(_email);
                              });
                            }),
                            decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(
                                color: Colors.black87,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            textAlign: TextAlign.center,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter full name';
                              }
                              return null;
                            },
                          ),

                          //========================================== Email Address
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            child: TextFormField(
                              controller: email,
                              onChanged: ((String email) {
                                setState(() {
                                  _email = email;
                                  print(_email);
                                });
                              }),
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                labelStyle: TextStyle(
                                  color: Colors.black87,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              textAlign: TextAlign.center,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter email address';
                                }
                                return null;
                              },
                            ),
                          ),

                          //===================================================== Emergency Contact

                          Container(
                            margin: EdgeInsets.only(top: 25),
                            child: TextFormField(
                              controller: email,
                              onChanged: ((String email) {
                                setState(() {
                                  _email = email;
                                  print(_email);
                                });
                              }),
                              decoration: InputDecoration(
                                labelText: "Contact Number",
                                labelStyle: TextStyle(
                                  color: Colors.black87,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter emergency contact number';
                                }
                                return null;
                              },
                            ),
                          ),
                          //========================================================Button

                          Center(
                            child: Container(
                              width: 300,
                              margin: EdgeInsets.only(top: 50),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.blue),
                              child: FlatButton(
                                child: FittedBox(
                                    child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                )),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
//============================================================================================================= Form Finished
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
