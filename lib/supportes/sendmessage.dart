import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imagekit_io/imagekit_io.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:miniquora/connectordata/discussion.dart';
import 'package:miniquora/supportes/sizesupporters.dart';
import 'package:miniquora/supportes/stylesupporters.dart';
import 'package:shared_preferences/shared_preferences.dart';

senddiscussion(BuildContext context) {
  String filepath = "";
  late File file;
  var byte = null;
  TextEditingController titleText = TextEditingController();
  TextEditingController bodytext = TextEditingController();
  bool isLoading = false;
  showDialog(
      context: context,
      builder: (context) => Material(
          color: Colors.transparent,
          child: StatefulBuilder(builder: (context, state) {
            print(filepath);
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 200, vertical: 100),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Stack(
                children: [
                  if (byte != null)
                    Positioned(
                        right: 40,
                        top: 98,
                        width: 270,
                        height: 270,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            byte,
                            fit: BoxFit.cover,
                          ),
                        )),
                  Positioned(
                    bottom: 60,
                    right: 60,
                    child: InkWell(
                      onTap: () {
                        if (titleText.text.isNotEmpty &&
                            bodytext.text.isNotEmpty) {
                          state(() {
                            isLoading = true;

                            if (byte != null) {
                              ImageKit.io(
                                byte,
                                //  folder: "folder_name/nested_folder", (Optional)
                                privateKey:
                                    "private_/ixEFm8zmvLC+cRnpsQoDFgPdQ0=", // (Keep Confidential)
                                onUploadProgress: (progressValue) {},
                                fileName: DateTime.now().toString(),
                              ).then((ImagekitResponse data) {
                                print(data.url);
                                state(() {
                                  isLoading = false;
                                  uploadquestion(
                                      titleText.text.trim(),
                                      bodytext.text.trim(),
                                      data.url.toString(),
                                      context);
                                });
                              }).catchError((e) {
                                print(e);
                                Fluttertoast.showToast(
                                    msg: "something went to wrong");
                                isLoading = false;
                              });
                            } else {
                              uploadquestion(titleText.text.trim(),
                                  bodytext.text.trim(), filepath, context);
                            }
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please input title and body");
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green),
                        child: (isLoading)
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white, size: 22)
                            : Row(
                                children: [
                                  Icon(
                                    Icons.upload,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  width(5),
                                  Text(
                                    "Upload Question ",
                                    style: tx600(17, Color: Colors.white),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    top: 40,
                    width: 700,
                    bottom: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Post your Question",
                          style: tx600(22, Color: Colors.black),
                        ),
                        height(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                "Question Title    :",
                                style: tx500(18, Color: Colors.black),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.09)),
                              padding: EdgeInsets.only(
                                  top: 8, left: 8, right: 8, bottom: 8),
                              alignment: Alignment.topLeft,
                              height: 110,
                              child: TextField(
                                maxLines: null,
                                controller: titleText,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    isDense: true,
                                    hintText: "Type your question heading"),
                              ),
                            ))
                          ],
                        ),
                        height(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                "Question Body    :",
                                style: tx500(18, Color: Colors.black),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.09)),
                              padding: EdgeInsets.only(
                                  top: 8, left: 8, right: 8, bottom: 8),
                              alignment: Alignment.topLeft,
                              height: 210,
                              child: TextField(
                                maxLines: null,
                                controller: bodytext,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    isDense: true,
                                    hintText: "Type your content of question"),
                              ),
                            ))
                          ],
                        ),
                        height(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                "Image (Optional) :",
                                style: tx500(18, Color: Colors.black),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png', 'jpeg'],
                                );

                                if (result != null) {
                                  //    print(result.files[0].path);
                                  state(() {
                                    filepath = "content_image";
                                    byte = result.files[0].bytes;
                                    print(byte);
                                  });
                                  //file = File("content.jpg");
                                } else {
                                  // User canceled the picker
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Text("Pick image file"),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.grey.withOpacity(.09)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          })));
}

uploadquestion(
    String title, String body, String image, BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String senderid = preferences.getString("EMAIL").toString();
  String name = preferences.getString("NAME").toString();
  String datetime = DateTime.now().toString();
  Discussion dis = Discussion(
      name: name,
      sender: senderid,
      datetime: datetime,
      image: image,
      title: title,
      body: body);
  print(dis.toJson());

  CollectionReference messages =
      FirebaseFirestore.instance.collection('contents');
  messages.doc("$name-$datetime").set({
    "name": dis.name,
    "sender": dis.sender,
    "image": image,
    "title": title,
    "body": body,
    "datetime": datetime
  }).whenComplete(() {
    print("completed");
    Navigator.of(context).pop();
  });
}
