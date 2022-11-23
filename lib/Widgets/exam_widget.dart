import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:school_diary_sept_13/Screens/AFL_Screen.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';

import '../Screens/home_screen.dart';

class ExamWidget extends StatefulWidget {
  final String? studId;
  final String? schlId;
  final String? qpId;
  final String? date;
  final String? subName;
  final String? activityName;
  final List<dynamic>? themes;
  final String? markObt;
  final String? maxMark;
  final Color? color;
  final Function? aflOn;
  const ExamWidget(
      {Key? key,
      this.aflOn,
      this.color,
      this.date,
      this.maxMark,
      this.activityName,
      this.markObt,
      this.subName,
      this.themes,
      this.studId,
      this.qpId,
      this.schlId})
      : super(key: key);

  @override
  State<ExamWidget> createState() => _ExamWidgetState();
}

class _ExamWidgetState extends State<ExamWidget> with SingleTickerProviderStateMixin {
  var _isExpanded = false;
  AnimationController? _controller;
  Animation<Size>? _heightanimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 300));
    _heightanimation = _controller!.drive(

        Tween<Size>(

      begin: Size(double.infinity, (140+widget.themes!.length * 10)),end: Size(double.infinity, 190+(widget.themes!.length * 25))
    ));
    _heightanimation!.addListener(()=>setState(() {

    }));
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
        if(_isExpanded){
          _controller!.forward();
        }else{
          _controller!.reverse();
        }
      },
      child: Container(
        width: 1.sw,
       // height: _heightanimation!.value.height,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        //color: Colors.red,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: (140 + widget.themes!.length * 10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              // color: Colors.green,
              decoration: BoxDecoration(
                  color: widget.color, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    '${DateFormat('dd MMM').format(DateTime.parse(widget.date!.split(' ')[0])).split(' ')[0]}',
                    style: TextStyle(
                        color: ColorUtil.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        //fontStyle:  FontStyle.normal,
                        fontSize: 20.sp),
                  )),
                  Center(
                      child: Text(
                    '${DateFormat('dd MMM').format(DateTime.parse(widget.date!.split(' ')[0])).split(' ')[1].toUpperCase()}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: ColorUtil.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                    ),
                  )),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  width: 1.sw - 130,
                  //height: 140,
                  height: _heightanimation!.value.height ,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x24161616),
                            offset: Offset(0, 7),
                            blurRadius: 24,
                            spreadRadius: 0)
                      ],
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.subName!,
                            style: TextStyle(
                                color: widget.color,
                                fontWeight: FontWeight.w600,
                                fontFamily: "OpenSans",
                                fontStyle: FontStyle.normal,
                                fontSize: 15.sp),
                          ),
                          (widget.markObt.toString() == 'null')
                              ? Row(
                                children: [
                                  Container(
                                      width: 80,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: ColorUtil.circularRed,
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Center(
                                        child: Text(
                                          'Absent',
                                          style: TextStyle(
                                            fontFamily: 'Axiforma',
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            //fontStyle: FontStyle.normal,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                 _isExpanded? Icon(Icons.arrow_drop_up):Icon(Icons.arrow_drop_down)
                                ],
                              )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => AFLReport(
                                                  qpId: widget.qpId,
                                                  studId: widget.studId,
                                                  schlId: widget.schlId,
                                                  nos: widget.maxMark,
                                                  score: widget.markObt,
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 65,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: ColorUtil.subBlue,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye_outlined,
                                              size: 14,
                                              color: ColorUtil.white,
                                            ),
                                            Text(
                                              'View',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "OpenSans",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 13.sp),
                                            ),
                                          ],
                                        )),
                                      ),
                                      _isExpanded
                                          ? Icon(Icons.arrow_drop_up)
                                          : Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      Divider(),
                      Text(widget.activityName!),
                      (_heightanimation!.value.height == 190+(widget.themes!.length * 25)) ? Divider() : SizedBox(),
                      (_heightanimation!.value.height == 190+(widget.themes!.length * 25))
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Topic',
                                  style: TextStyle(
                                      color: const Color(0xff4b4b4b),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "OpenSans",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15.sp),
                                ),
                                Column(
                                  children: [
                                    ...widget.themes!
                                        .map((e) =>
                                        Container(width: 150, child: Text(e)))
                                        .toList(),
                                  ],
                                )

                              ],
                            )
                          : SizedBox(
                              height: 10,
                            ),
                      (_heightanimation!.value.height == 190+(widget.themes!.length * 25)) ? Divider() : SizedBox(),
                      Container(
                        width: 1.sw,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 30,
                              // color: Colors.grey,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    //color: Colors.green,
                                    decoration: BoxDecoration(
                                        color: ColorUtil.green,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                        child: Text(
                                      (widget.markObt.toString() == 'null')
                                          ? 'NA'
                                          : '${widget.markObt!}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Axiforma",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.sp),
                                    )),
                                  ),
                                  Text(
                                    '/',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: ColorUtil.greybg,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(child: Text(widget.maxMark!)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
