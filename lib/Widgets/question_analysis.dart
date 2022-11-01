import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionAnalysis extends StatelessWidget {
  const QuestionAnalysis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 200,
     margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
     // color: Colors.red,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            ),
            boxShadow: [BoxShadow(
                color: const Color(0x78aeaed8),
                offset: Offset(0,10),
                blurRadius: 32,
                spreadRadius: 0
            )] ,
            color: Colors.white
        ),
    );
  }
}
