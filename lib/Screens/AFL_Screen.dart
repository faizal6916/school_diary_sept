import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';

class AFLReport extends StatefulWidget {
  const AFLReport({Key? key}) : super(key: key);

  @override
  State<AFLReport> createState() => _AFLReportState();
}

class _AFLReportState extends State<AFLReport> {
  List<String> dropDown = <String>[
    'Analysis',
    'Score Comparison',
    'Topic Analysis',
    'Activity Report',
  ];
  String dropdownvalue = 'Analysis';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 1.sw,
                height: 280,
              ),
              Container(
                width: 1.sw,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/MaskGroup3.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.arrow_back,
                          color: ColorUtil.white,
                          size: 36,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 1.sw - 50,
                        child: Center(
                            child: Text(
                          'AFL Reports ',
                          style: TextStyle(
                              fontSize: 24.sp, color: ColorUtil.white),
                        )))
                  ],
                ),
              ),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Container(
                  width: 1.sw,
                  height: 180,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //color: Colors.red,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0x24161616),
                          offset: Offset(0, 7),
                          blurRadius: 24,
                          spreadRadius: 0)
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 1.sw / 2 - 40,
                            height: 70,
                            //color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  // color: Colors.green,
                                  decoration: BoxDecoration(
                                      color: ColorUtil.green,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '15',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Axiforma",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 18.0),
                                          ),
                                          Text(
                                            '/',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                // fontFamily: "Axiforma",
                                                // fontStyle:  FontStyle.normal,
                                                fontSize: 18.0),
                                          ),
                                          Text(
                                            '15',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                // fontFamily: "Axiforma",
                                                // fontStyle:  FontStyle.normal,
                                                fontSize: 18.0),
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Scored',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Axiforma",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  height: 70,
                                  // color: Colors.green,
                                  decoration: BoxDecoration(
                                      //color: ColorUtil.green,
                                      border:
                                          Border.all(color: ColorUtil.greybg),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '15',
                                        style: const TextStyle(
                                            color: const Color(0xff090909),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Axiforma",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        'Questions',
                                        style: const TextStyle(
                                            color: const Color(0xff090909),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Axiforma",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                width: 1.sw / 2 - 40,
                                height: 50,
                                //color: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    // border: Border(bottom: BorderSide(color: Colors.black26)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color(0x78aeaed8),
                                          offset: Offset(0, 10),
                                          blurRadius: 32,
                                          spreadRadius: 0)
                                    ],
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                        image: AssetImage(
                                            'assets/images/remark.png')),
                                    Text('Remarks'),
                                    Transform.rotate(
                                        angle: 180 * math.pi / 180,
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          size: 14,
                                        ))
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 1.sw / 2 - 40,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      color: ColorUtil.tabIndicator,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15))),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 1.sw / 2 - 40,
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                // color: Colors.red,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color(0x78aeaed8),
                                          offset: Offset(0, 10),
                                          blurRadius: 32,
                                          spreadRadius: 0)
                                    ],
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                        image: AssetImage(
                                            'assets/images/question.png')),
                                    Text('Question Analysis'),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 1.sw / 2 - 40,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      color: ColorUtil.tabIndicator,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15))),
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: 1.sw / 2 - 40,
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            //color: Colors.red,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0x78aeaed8),
                                      offset: Offset(0, 10),
                                      blurRadius: 32,
                                      spreadRadius: 0)
                                ],
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image(image: AssetImage('assets/images/analysis.png')),
                                DropdownButton<String>(
elevation: 0,
                                    
                                    value: dropdownvalue,
                                    items: dropDown
                                        .map((menu) => DropdownMenuItem<String>(
                                       value: menu,
                                            child: SizedBox(
                                              width: 80,
                                                child: Text(menu,maxLines: 2,))))
                                        .toList(),
                                    onChanged: (value) {
                                      print(value);
                                      setState((){
                                        dropdownvalue = value!;
                                        print(dropdownvalue);
                                      });

                                    }),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Text('Analysis')
        ],
      ),
    );
  }
}
