import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:miniquora/supportes/stylesupporters.dart';
import 'package:miniquora/temp.dart';

class answerbox extends StatelessWidget {
  var answerDate;
  answerbox({super.key, required this.answerDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      margin: EdgeInsets.only(top: 7),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  answerDate.get("name"),
                  style: tx600(18, Color: Colors.black),
                ),
              ),
              Text(
                answerDate.get("datetime"),
                style: tx500(14, Color: Colors.black),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              answerDate.get("body"),
              style: tx600(15, Color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }
}
