// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_keyColor_in_widget_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, unused_element, file_names, use_build_context_synchronously, avoid_print, non_constant_identifier_names, unnecessary_new, unused_catch_stack, unused_local_variable, sort_child_properties_last

import 'package:ecm_application/Model/Project/Login/LoginModel.dart';
import 'package:ecm_application/Operations/LoginOperations.dart';
import 'package:ecm_application/Screens/Login/Dashboard.dart';
import 'package:ecm_application/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height, // 0.40,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(gradient: ColorConstant.appBarGradient),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 125),
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage("assets/images/SeLogo.png"),
                              height: 150,
                              // width: 400,
                            ),
                            Text(
                              "Erection, Commission & Maintenance Application",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstant.green900,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ))),
                Positioned(
                  bottom: 0,
                  left: 0.1,
                  right: 0.1,
                  child: LoginFormWidget(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormWidgetState();
  }
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  var UsernameController = TextEditingController();
  var passwordController = TextEditingController();
  var _emailFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = true;
  bool _autoValidate = false;
  var sizedbox = SizedBox(
    height: 15,
  );
  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // sizedbox,
            sizedbox,
            _buildPhoneField(context),
            _buildPasswordField(context),
            _buildForgotPassword(context),
            _buildLogInButton(context),
            sizedbox,
          ],
        ),
      ),
    );
  }

  _passwordValidation(String value) {
    if (value.isEmpty) {
      return "Please enter password";
    } else {
      return null;
    }
  }

  Widget _buildPhoneField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
      child: TextFormField(
          controller: UsernameController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          validator: (value) => _phoneValidation(value.toString()),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
              labelStyle: TextStyle(color: Colors.black),
              // hintText: 'hello@rgmail.com',
              labelText: 'Mobile No.')),
    );
  }

  _phoneValidation(String value) {
    bool emailValid = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value);
    if (!emailValid) {
      return "Enter valid Mobile";
    } else {
      return null;
    }
  }

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
      child: TextFormField(
        controller: passwordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        validator: (value) => _passwordValidation(value.toString()),
        obscureText: _isPasswordVisible,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock),
          labelText: "Password",
          hintText: "",
          labelStyle: TextStyle(color: Colors.black),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
        ),
      ),
    );
  }

  Widget _buildLogInButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: ElevatedButton(
            child: Center(child: Text("Login")),
            style: ElevatedButton.styleFrom(
              // backgroundColor: Colors.teal,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.all(20),
            ),
            onPressed: () async {
              _signUpProcess(context);
            }));
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(
          //   child: Row(children: [
          //     Checkbox(
          //       value: this.valuefirst,
          //       activeColor: Colors.black,
          //       onChanged: (bool? value) {
          //         setState(() {
          //           this.valuefirst = value!;
          //         });
          //       },
          //     ),
          //     Text("Remember me"),
          //   ]),
          // ),
          TextButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ForgotPasswordScreen()));
              },
              child: Text(
                "Forgot Password",
                style: TextStyle(color: ColorConstant.gray600),
              ))
        ],
      ),
    );
  }

  void _signUpProcess(BuildContext context) async {
    var validate = _formKey.currentState!.validate();
    try {
      print(UsernameController.text);
      LoginMasterModel? data = await fetchLoginDetails(
        UsernameController.text.toString(),
        passwordController.text.toString(),
      );
      if (data != null) {
        print(data.fName!);
        if (passwordController.text == data.pwd) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('mobileno', UsernameController.text);
          preferences.setString('firstname', data.fName!);
          preferences.setString('lastname', data.lName!);
          preferences.setInt('userid', data.userid!);
          preferences.setString('usertype', data.userType!);
          preferences.setString('Password', data.pwd!);
          getpop(context, data);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Wrong Cradentials ",
                  textScaleFactor: 1,
                ),
              ],
            )),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Enter Cradentials ",
                textScaleFactor: 1,
              ),
            ],
          )),
        );
      }
    } catch (_, ex) {}
  }

  getpop(context, LoginMasterModel? data) {
    return showDialog(
      barrierColor: Colors.black54,
      barrierDismissible: false,
      useSafeArea: false,
      context: context,
      builder: (ctx) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                gradient: ColorConstant.appBarGradient,
                // color: ColorConstant.cyan301,
                borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            width: size.width * 0.75,
            height: size.height * 0.45,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  // height: size.height * 0.15,
                  // width: size.width * 0.5,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage("assets/images/SeLogo.png"),
                        height: 100,
                        width: 100,
                      ),
                      Text(
                        "ECM",
                        style: TextStyle(
                            color: ColorConstant.green900,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                // Welcome Text
                Container(
                  height: 100,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Welcome",
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data!.fName.toString(),
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: ColorConstant.whiteA700,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data.userType.toString(),
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ]),
                ),

                ///Button
                Container(
                  width: size.width * 0.3,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.blue)))),
                      child: Text("OK",
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProjectsCategoryScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
