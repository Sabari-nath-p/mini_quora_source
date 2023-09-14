import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:miniquora/Screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../supportes/sizesupporters.dart';
import '../supportes/stylesupporters.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  int state = 0;
  bool loading = false;
  bool isvisible = false;
  TextEditingController emailtext = TextEditingController();
  TextEditingController passwordtext = TextEditingController();
  TextEditingController nametext = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.loose,
          children: [
            Positioned(
                left: 20,
                right: 0,
                bottom: 0,
                top: 0,
                child: Image.asset(
                  "assets/images/login-bg.jpg",
                  fit: BoxFit.fill,
                )),
            if (state == 0)
              Positioned(
                  top: 250,
                  left: 100,
                  right: 830,
                  bottom: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Back, Mini Quora",
                        style: tx700(22),
                      ),
                      height(10),
                      Text(
                        "make your discussion globle",
                        style: tx500(16),
                      ),
                      height(40),
                      Container(
                        width: 280,
                        child: TextField(
                          controller: emailtext,
                          decoration: InputDecoration(
                              hintText: "Email ID",
                              labelText: "Enter Email ID"),
                        ),
                      ),
                      height(10),
                      Container(
                        width: 280,
                        child: TextField(
                          controller: passwordtext,
                          obscureText: isvisible,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isvisible = !isvisible;
                                  });
                                },
                                child: Icon((isvisible)
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              hintText: "Passoword",
                              labelText: "Enter password"),
                        ),
                      ),
                      height(8),
                      Container(
                        width: 280,
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password',
                          style: tx600(14, Color: Colors.black),
                        ),
                      ),
                      height(20),
                      InkWell(
                        onTap: () {
                          if (emailtext.text.isNotEmpty &&
                              passwordtext.text.isNotEmpty) {
                            sendlogin(emailtext.text.trim(),
                                passwordtext.text.trim());
                          } else {
                            Fluttertoast.showToast(msg: "please fill data");
                          }
                        },
                        child: Container(
                          width: 260,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black),
                          child: (!loading)
                              ? Text(
                                  "Login back.",
                                  style: tx700(20, Color: Colors.white),
                                )
                              : LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white, size: 22),
                        ),
                      ),
                      height(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("you don't have an account,"),
                          InkWell(
                            onTap: () {
                              setState(() {
                                state = 1;
                              });
                            },
                            child: Text(
                              "Signup",
                              style: tx600(14, Color: Colors.black),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            if (state == 1)
              Positioned(
                  top: 250,
                  left: 100,
                  right: 830,
                  bottom: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Back, Mini Quora",
                        style: tx700(22),
                      ),
                      height(10),
                      Text(
                        "make your discussion globle",
                        style: tx500(16),
                      ),
                      height(40),
                      Container(
                        width: 280,
                        child: TextField(
                          controller: nametext,
                          decoration: InputDecoration(
                              hintText: "Profile Name",
                              labelText: "Enter profile name"),
                        ),
                      ),
                      height(10),
                      Container(
                        width: 280,
                        child: TextField(
                          controller: emailtext,
                          decoration: InputDecoration(
                              hintText: "Email ID",
                              labelText: "Enter Email ID"),
                        ),
                      ),
                      height(10),
                      Container(
                        width: 280,
                        child: TextField(
                          controller: passwordtext,
                          obscureText: isvisible,
                          decoration: InputDecoration(
                              hintText: "Passoword",
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isvisible = !isvisible;
                                  });
                                },
                                child: Icon((isvisible)
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              labelText: "Enter password"),
                        ),
                      ),
                      height(20),
                      InkWell(
                        onTap: () {
                          print("working");
                          if (emailtext.text.isNotEmpty &&
                              passwordtext.text.isNotEmpty &&
                              nametext.text.isNotEmpty) {
                            sendsignup(emailtext.text.trim(),
                                passwordtext.text.trim(), nametext.text.trim());
                          } else {
                            Fluttertoast.showToast(
                                msg: "please fill data to continue");
                          }
                        },
                        child: Container(
                          width: 260,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black),
                          child: (!loading)
                              ? Text(
                                  "Create Account",
                                  style: tx700(20, Color: Colors.white),
                                )
                              : LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white, size: 22),
                        ),
                      ),
                      height(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("already have account,"),
                          InkWell(
                            onTap: () {
                              setState(() {
                                state = 0;
                              });
                            },
                            child: Text(
                              "SignIn",
                              style: tx600(14, Color: Colors.black),
                            ),
                          )
                        ],
                      )
                    ],
                  ))
          ],
        ),
      ),
    );
  }

  sendlogin(String email, String password) {
    setState(() {
      loading = true;
    });
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    users.doc(email).get().then((value) async {
      if (value.exists) {
        if (password == value.get("password").toString()) {
          print(value.data());
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("LOGIN", "IN");
          pref.setString("EMAIL", email);
          pref.setString("PASSWORD", password);
          pref.setString("NAME", value.get("name").toString());
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => homeScreen()));
        } else {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(msg: "Login failed , invalid Credential");
        }
      } else {
        Fluttertoast.showToast(msg: "Login failed , invalid Credential");
        setState(() {
          loading = false;
        });
      }
    });
  }

  sendsignup(String email, String password, String name) {
    setState(() {
      loading = true;
    });
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    users
        .doc(email)
        .set({"password": password, "name": name}).whenComplete(() async {
      Fluttertoast.showToast(msg: "Account Created");
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("LOGIN", "IN");
      pref.setString("EMAIL", email);
      pref.setString("PASSWORD", password);
      pref.setString("NAME", name);
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => homeScreen()));
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "Something went to wrong, please try again");
    });
  }
}
