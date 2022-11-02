import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';

class QuestionAnalysis extends StatefulWidget {
  const QuestionAnalysis({Key? key}) : super(key: key);

  @override
  State<QuestionAnalysis> createState() => _QuestionAnalysisState();
}

class _QuestionAnalysisState extends State<QuestionAnalysis> with TickerProviderStateMixin {
  var _isExpanded = false;
  var _height = 250.0;
  Duration _myduration = Duration(seconds: 1);
  var _doneDur = false;
  // Animation<double>? _myAnimation;
  // AnimationController? _controller;
  Future _complete() async {
    Future.delayed(Duration(milliseconds: 900), () {
      setState(() {
        _doneDur = true;
      });
    });
  }
 @override
  void initState() {
    // TODO: implement initState
   // _controller = AnimationController(
   //   vsync: this,
   //   duration: Duration(milliseconds: 200),
   // );
   //
   // _myAnimation = CurvedAnimation(
   //     curve: Curves.linear,
   //     parent: _controller!
   // );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            _isExpanded = !_isExpanded;
            print(_isExpanded);
            if (_isExpanded) {
            //  _controller!.forward();
              setState(() {
                _height = 300.0;
              });
              _complete();
            } else {
             // _controller!.reverse();
              setState(() {
                _height = 250.0;
                _doneDur = false;
              });
            }
          },
          child: AnimatedContainer(
            duration: _myduration,
            curve: Curves.fastOutSlowIn,
            width: 1.sw,
            height: _height,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.only(top: 30, bottom: 50, left: 10, right: 10),
            // color: Colors.red,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x78aeaed8),
                      offset: Offset(0, 10),
                      blurRadius: 32,
                      spreadRadius: 0)
                ],
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Text(
                    'short answer',
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      color: Color(0xff979797),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      // color: Colors.red,
                      decoration: BoxDecoration(
                          color: ColorUtil.circularRed,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(child: Text('Q')),
                    ),
                    Container(
                      width: 1.sw - 90,
                      //height: 70,
                      //color: Colors.blue,
                      child: AutoSizeText(
                        'QUUUUUUUUUUUUUUUUU gjhggggggggggggggggggggggg HHHHHHHHHHHHHHHHHH HHHHHHHHHHHHHHHHHHH',
                        style: TextStyle(
                            color: const Color(0xff363636),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Axiforma",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  indent: 50,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      // color: Colors.red,
                      // decoration: BoxDecoration(color: ColorUtil.circularRed,borderRadius: BorderRadius.circular(10)),
                      // child: Center(child: Text('Q')),
                    ),
                    Container(
                      width: 1.sw - 90,
                      //height: 70,
                      //color: Colors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Students Response',
                            style: TextStyle(
                              color: Color(0xff1eb1ae),
                              fontSize: 14.sp,
                              fontFamily: 'Axiforma',
                            ),
                          ),
                          Text(
                            'A',
                            style: TextStyle(
                              color: Color(0xff818181),
                              fontSize: 14.sp,
                              fontFamily: 'Axiforma',
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                (_doneDur)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            // color: Colors.red,
                            decoration: BoxDecoration(
                                color: ColorUtil.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text('A')),
                          ),
                          Container(
                            width: 1.sw - 90,
                            //height: 70,
                            //color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Correct Answer',
                                  style: TextStyle(
                                    color: ColorUtil.green,
                                    fontSize: 14.sp,
                                    fontFamily: 'Axiforma',
                                  ),
                                ),
                                Text(
                                  'A',
                                  style: TextStyle(
                                    color: Color(0xff818181),
                                    fontSize: 14.sp,
                                    fontFamily: 'Axiforma',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                Row(
                  children: [
                    SizedBox(
                      width: 1.sw - 70,
                    ),
                   Transform.rotate(angle: _doneDur? (180 * math.pi/180):0,child: Icon(Icons.arrow_drop_down),)
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
            right: 20,
            child: Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: ColorUtil.green,
                  borderRadius: BorderRadius.circular(60)),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //SizedBox(height: 5,),
                  Text(
                    'mark',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Axiforma',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 3,
                    color: Colors.white,
                  ),
                  //Divider(thickness: 2,indent: 5,endIndent: 5,),
                  Text(
                    'max',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Axiforma',
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
