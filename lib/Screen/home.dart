import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miniquora/Screen/Login.dart';
import 'package:miniquora/connectordata/discussion.dart';
import 'package:miniquora/supportes/sendmessage.dart';
import 'package:miniquora/supportes/sizesupporters.dart';
import 'package:miniquora/supportes/stylesupporters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/answerbox.dart';
import '../components/messageBox.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDiscussion();
  }

  List discussionList = [];
  int option = 0;
  loadDiscussion() {
    CollectionReference messages =
        FirebaseFirestore.instance.collection('contents');
    messages.get().then((value) {
      print(value.docs);
      for (var mes in value.docChanges) {
        print(json.encode(mes.doc.data()));
        var response = json.decode(json.encode(mes.doc.data()));
        Discussion discussion = Discussion.fromJson(response);
        discussion.id = mes.doc.id;
        setState(() {
          discussionList.add(discussion);
        });
      }
    });
  }

  loaduserdiscussion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString("EMAIL").toString();
    CollectionReference messages =
        FirebaseFirestore.instance.collection('contents');
    messages.where("sender", isEqualTo: email).get().then((value) {
      print(value.docs);
      for (var mes in value.docChanges) {
        print(json.encode(mes.doc.data()));
        var response = json.decode(json.encode(mes.doc.data()));
        Discussion discussion = Discussion.fromJson(response);
        discussion.id = mes.doc.id;
        setState(() {
          discussionList.add(discussion);
        });
      }
    });
  }

  List answer = [];
  String currentAnswer = "";
  loadanswer(String qid) {
    print("wroking");
    FirebaseFirestore ref = FirebaseFirestore.instance;
    print(qid);
    ref.collection("answer").doc(qid).collection('answer').get().then((value) {
      print(value.docs);
      for (var vm in value.docs) {
        setState(() {
          answer.add(vm);
          print("answer");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xfff6f7fb),
      body: Stack(
        children: [
          // side  menu box
          Positioned(
              left: 0,
              bottom: 0,
              top: 10,
              width: 280,
              child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(70),
                      InkWell(
                        onTap: () {
                          setState(() {
                            option = 0;
                            discussionList.clear();
                            currentAnswer = "";
                            loadDiscussion();
                          });
                        },
                        child: Text(
                          "  Discussion",
                          style: tx600(19,
                              Color:
                                  (option == 0) ? Colors.orange : Colors.black),
                        ),
                      ),
                      height(20),
                      InkWell(
                        onTap: () {
                          setState(() {
                            option = 1;
                            discussionList.clear();
                            currentAnswer = "";
                            loaduserdiscussion();
                          });
                        },
                        child: Text(
                          "  My Collection",
                          style: tx600(19,
                              Color:
                                  (option == 1) ? Colors.orange : Colors.black),
                        ),
                      ),
                      height(20),
                      InkWell(
                        onTap: () {
                          // discussionList.clear();
                          //  loadDiscussion();
                          Fluttertoast.showToast(msg: "currently not avalible");
                        },
                        child: Text(
                          "  Saved Discussion",
                          style: tx600(19, Color: Colors.black),
                        ),
                      ),
                      height(10),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        color: Colors.black.withOpacity(.1),
                        height: 1,
                      ),
                      Expanded(child: Container()),
                      InkWell(
                        onTap: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString("LOGIN", "OUT");
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => login()));
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(.2)),
                          child: Text(
                            "Logout",
                            style: tx600(16, Color: Colors.black),
                          ),
                        ),
                      ),
                      height(10)
                    ],
                  ))),
          // top menu icon and message button
          Positioned(
              left: 300,
              top: 30,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      senddiscussion(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                          width(5),
                          Text(
                            "Ask a Question",
                            style: tx600(17, Color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  width(10),
                  Icon(
                    Icons.notifications_outlined,
                    color: Colors.grey.withOpacity(.6),
                  ),
                  width(10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        discussionList.clear();
                        loadDiscussion();
                      });
                    },
                    child: Icon(
                      Icons.change_circle,
                      color: Colors.grey.withOpacity(.6),
                    ),
                  ),
                  width(10),
                ],
              )),

          //question box
          Positioned(
              left: 300,
              top: 100,
              bottom: 10,
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (Discussion discussion in discussionList)
                        InkWell(
                            onTap: () {
                              setState(() {
                                answer = [];
                                currentAnswer = discussion.id!;
                                loadanswer(discussion.id!);
                              });
                            },
                            child: messageBox(discussion: discussion))
                    ],
                  ),
                ),
              )),

          // amswer box
          if (currentAnswer != "")
            Positioned(
                right: 50,
                width: 400,
                top: 118,
                bottom: 100,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white38),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Text(
                          "Answer & Reply",
                          style: tx600(18, Color: Colors.black),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var ans in answer)
                                answerbox(
                                  answerDate: ans,
                                ),
                            ],
                          ),
                        ),
                      )),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              height: 45,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white),
                              child: TextField(
                                controller: answerText,
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    isDense: true,
                                    hintText: "Write your answer"),
                              ),
                            )),
                            width(10),
                            InkWell(
                              onTap: () async {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                String senderid =
                                    preferences.getString("EMAIL").toString();
                                String name =
                                    preferences.getString("NAME").toString();
                                String datetime = DateTime.now().toString();
                                FirebaseFirestore db =
                                    FirebaseFirestore.instance;
                                db
                                    .collection("answer")
                                    .doc(currentAnswer)
                                    .collection("answer")
                                    .add({
                                  "name": name,
                                  "sender": senderid,
                                  "body": answerText.text.trim(),
                                  "datetime": datetime
                                }).then((value) {
                                  Fluttertoast.showToast(msg: "Answer added");
                                  answer.clear();
                                  loadanswer(currentAnswer);
                                });
                                setState(() {
                                  answerText.text = "";
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.send,
                                  color: Colors.blueGrey.withOpacity(.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))
        ],
      ),
    ));
  }

  TextEditingController answerText = TextEditingController();
}
