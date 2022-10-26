import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../Util/color_util.dart';

class CatFour extends StatelessWidget {
  final String? title;
  final String? url;
  final String? date;
  const CatFour({Key? key,this.title,this.url,this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      width: 1.sw,
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x94aeaed8),
            offset: Offset(0, 10),
            blurRadius: 32,
            spreadRadius: 0,
          ),
        ],
      ),
      // color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title!,style: TextStyle(
              color: ColorUtil.tabIndicator,
              fontWeight: FontWeight.w500,
              fontFamily: "Axiforma",
              // fontStyle:  FontStyle.normal,
              fontSize: 18.sp
          ),),
          Container(width: 80,
            //color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${DateFormat('MMM dd').format(DateTime.parse(date!))}', style: TextStyle(
                    color:  ColorUtil.calendarFont,
                    fontWeight: FontWeight.w400,
                    //fontFamily: "Axiforma",
                    //fontStyle:  FontStyle.normal,
                    fontSize: 14.sp
                ),),
                Icon(Icons.arrow_circle_down)
              ],
            ),)
        ],
      ),
    );
  }
}
