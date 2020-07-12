import 'package:flutter/material.dart';
import 'package:mobileappflutter/Helper/dialog_helper.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/user_service.dart';
import 'package:mobileappflutter/Style/color.dart';
import 'package:shimmer/shimmer.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final UserService _userService = UserService();

  final Color textColor = Colors.white;
  bool _statusInformation = true;
  bool _statusSecurity = true;
  final FocusNode myFocusNode = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formSecurityKey = GlobalKey<FormState>();
  final _formInformationKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(text: "somerandomtexttofake");
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: AppColor.mainColor,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        FutureBuilder(
                          future: _userService.refreshCurrentUser(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[500],
                                        highlightColor: Colors.grey[400],
                                        enabled: true,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0, right: 25.0, top: 25.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text(
                                                          'Personal Information',
                                                          style: TextStyle(
                                                              color: textColor,
                                                              fontSize: 18.0,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        CircleAvatar(
                                                          backgroundColor: Colors.grey,
                                                          radius: 14.0
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0, right: 25.0, top: 25.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text(
                                                          'Name',
                                                          style: TextStyle(
                                                              color: textColor,
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0, right: 25.0, top: 2.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: TextFormField(
                                                        decoration: const InputDecoration(
                                                          hintText: "Loading ...",
                                                          hintStyle: TextStyle(
                                                              color: Colors.white, fontSize: 14),
                                                        ),
                                                        style: TextStyle(
                                                          color: textColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0, right: 25.0, top: 25.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text(
                                                          'Email',
                                                          style: TextStyle(
                                                              color: textColor,
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0, right: 25.0, top: 2.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: TextFormField(
                                                        decoration: const InputDecoration(
                                                          hintText: "Loading ...",
                                                          hintStyle: TextStyle(
                                                              color: Colors.white, fontSize: 14),
                                                        ),
                                                        style: TextStyle(
                                                          color: textColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              );
                            } else {
                              User user = snapshot.data;
                              _usernameController.text = user.username;
                              _emailController.text = user.email;
                              return Form(
                                key: _formInformationKey,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Personal Information',
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                _statusInformation
                                                    ? _getEditInformationIcon()
                                                    : Container(),
                                              ],
                                            )
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 2.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                decoration: const InputDecoration(
                                                  hintText: "Enter Your Name",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white, fontSize: 14),
                                                ),
                                                controller: _usernameController,
                                                enabled: !_statusInformation,
                                                autofocus: !_statusInformation,
                                                style: TextStyle(
                                                  color: textColor,
                                                ),
                                                validator: (val) => val.length < 4 ? 'Username required' : null,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Email',
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 2.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                decoration: const InputDecoration(
                                                  hintText: "Enter Email",
                                                  hintStyle: TextStyle(
                                                      color: Colors.white, fontSize: 14),
                                                ),
                                                controller: _emailController,
                                                enabled: !_statusInformation,
                                                style: TextStyle(
                                                  color: textColor,
                                                ),
                                                validator: (val) {
                                                  if(val.isEmpty)
                                                    return "Email required";
                                                  if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val))
                                                    return "Email not valid";
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        )),
                                    !_statusInformation
                                        ? _getActionInformationButtons()
                                        : Container(),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Colors.black,
                          height: 50,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: _formSecurityKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Security Information',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _statusSecurity
                                              ? _getEditSecurityIcon()
                                              : Container(),
                                        ],
                                      )
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Password',
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: "Enter your new password",
                                            hintStyle: TextStyle(
                                                color: Colors.white, fontSize: 14),
                                          ),
                                          controller: _passwordController,
                                          obscureText: true,
                                          enabled: !_statusSecurity,
                                          autofocus: !_statusSecurity,
                                          style: TextStyle(
                                            color: textColor,
                                          ),
                                          validator: (val){
                                            if(val.isEmpty)
                                              return 'Password required';
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                              !_statusSecurity
                                  ? _getActionSecurityButtons()
                                  : Container(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionInformationButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                    child: Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      if (_formSecurityKey.currentState.validate()) {
                        final snackbar = SnackBar(
                          duration: Duration(seconds: 30),
                          content: Row(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Text("  Updating information...")
                            ],
                          ),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackbar);
                        _userService.updateUser(
                            username: _usernameController.text,
                            email: _emailController.text
                        ).then((result) async {
                          if (result) {
                            final snackbar = SnackBar(
                              duration: Duration(seconds: 5),
                              content: Row(
                                children: <Widget>[
                                  Text("Information updated succesfully")
                                ],
                              ),
                            );
                            _scaffoldKey.currentState.showSnackBar(snackbar);

                            await Future.delayed(Duration(seconds: 2));
                            _scaffoldKey.currentState.hideCurrentSnackBar();

                            setState(() {
                              _statusInformation = true;
                              FocusScope.of(context).requestFocus(FocusNode());
                            });
                          } else {
                            _scaffoldKey.currentState.hideCurrentSnackBar();
                            DialogHelper.displayDialog(context, 'Info', "Could not update your account information, please retry");
                          }
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                    child: Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _statusInformation = true;
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getActionSecurityButtons() {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Confirm your new password",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      controller: _confirmPasswordController,
                      obscureText: true,
                      enabled: !_statusSecurity,
                      style: TextStyle(
                        color: textColor,
                      ),
                      validator: (val){
                        if(val.isEmpty)
                          return 'Confirm password required';
                        if(val != _passwordController.text)
                          return 'Both password not match';
                        return null;
                      }
                  ),
                ),
              ],
            )),
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Container(
                      child: RaisedButton(
                        child: Text("Save"),
                        textColor: Colors.white,
                        color: Colors.green,
                        onPressed: () async {
                          if (_formSecurityKey.currentState.validate()) {
                            final snackbar = SnackBar(
                              duration: Duration(seconds: 30),
                              content: Row(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  Text("  Updating password...")
                                ],
                              ),
                            );
                            _scaffoldKey.currentState.showSnackBar(snackbar);
                            _userService.updatePasswordUser(_passwordController.text).then((result) async {
                              if (result) {
                                final snackbar = SnackBar(
                                  duration: Duration(seconds: 5),
                                  content: Row(
                                    children: <Widget>[
                                      Text("Password updated succesfully")
                                    ],
                                  ),
                                );
                                _scaffoldKey.currentState.showSnackBar(snackbar);

                                await Future.delayed(Duration(seconds: 2));
                                _scaffoldKey.currentState.hideCurrentSnackBar();

                                setState(() {
                                  _passwordController.text = "somerandomtexttofake";
                                  _confirmPasswordController.clear();
                                  _statusSecurity = true;
                                  FocusScope.of(context).requestFocus(FocusNode());
                                });
                              } else {
                                _scaffoldKey.currentState.hideCurrentSnackBar();
                                DialogHelper.displayDialog(context, 'Info', "Could not update your password, please retry");
                                _passwordController.clear();
                                _confirmPasswordController.clear();
                              }
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                  )),
                ),
                flex: 2,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Container(
                      child: RaisedButton(
                        child: Text("Cancel"),
                        textColor: Colors.white,
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            _passwordController.text = "somerandomtexttofake";
                            _confirmPasswordController.clear();
                            _statusSecurity = true;
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                  )),
                ),
                flex: 2,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _getEditInformationIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _statusInformation = false;
        });
      },
    );
  }

  Widget _getEditSecurityIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _passwordController.clear();
          _confirmPasswordController.clear();
          _statusSecurity = false;
        });
      },
    );
  }
}
