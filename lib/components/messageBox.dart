import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:miniquora/connectordata/discussion.dart';
import 'package:miniquora/supportes/sizesupporters.dart';
import 'package:miniquora/supportes/stylesupporters.dart';
import 'package:miniquora/temp.dart';

class messageBox extends StatefulWidget {
  Discussion discussion;
  messageBox({super.key, required this.discussion});

  @override
  State<messageBox> createState() => _messageBoxState(discussion: discussion);
}

class _messageBoxState extends State<messageBox> {
  Discussion discussion;
  _messageBoxState({required this.discussion});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 720,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.network(
                    "https://th.bing.com/th/id/OIP.audMX4ZGbvT2_GJTx2c4GgHaHw?pid=ImgDet&rs=1",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              width(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    discussion.name.toString(),
                    style: tx600(16, Color: Colors.black),
                  ),
                  Text(
                    discussion.datetime.toString(),
                    style: tx400(14, Color: Colors.black54),
                  ),
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 30),
            child: Text(
              discussion.title.toString(),
              style: tx700(20, Color: Colors.black),
            ),
          ),
          Container(
            width: 700,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      left: 10,
                      top: 20,
                    ),
                    child: Text(
                      discussion.body.toString(),
                      style: tx500(18, Color: Colors.black54),
                    ),
                  ),
                ),
                if (discussion.image != "" && discussion.image != "null")
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                          width: 230,
                          height: 140,
                          child: Image.network(
                            discussion.image.toString(),
                            fit: BoxFit.fill,
                          )))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
