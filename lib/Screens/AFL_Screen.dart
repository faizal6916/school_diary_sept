import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';
import 'package:school_diary_sept_13/Widgets/afl_remark.dart';
import 'package:school_diary_sept_13/Widgets/question_analysis.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Models/barchart.dart';
import '../Models/question_model.dart';
import '../Provider/user_provider.dart';
import '../Util/spinkit.dart';

class AFLReport extends StatefulWidget {
  final String? studId;
  final String? schlId;
  final String? qpId;
  final String? score;
  final String? nos;
  const AFLReport({Key? key, this.schlId, this.qpId, this.studId,this.nos,this.score,})
      : super(key: key);

  @override
  State<AFLReport> createState() => _AFLReportState();
}

class _AFLReportState extends State<AFLReport> {
  List<ChartData> _chData = [];
  List<ComparisonChart> _compData = [];
  List<ChartData> _timeElapsed = [];
  List<QuestionAnswer> _questionData = [];
  var _isloading = false;
  var _remedial;
  _getAFLReport(String stdId, String qpId, String schlId) async {
    try {
      setState(() {
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getAFLReport(stdId, qpId, schlId);
      // print(resp.runtimeType);
      //report.clear();

      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });

        _remedial = resp['data']['details']['response']['studentScore']['comment'];

        print(_remedial);
     //   print(resp['data']['details']['response']['getAllstudentMCQ']);
        resp['data']['details']['response']['getAllstudentMCQ'].forEach((que){
          print(que['question'].toString());
          print(que['type']);
          print(que['right_answer']['tag']);
          print(que['student_response']['score']);
          print(que['correct_answer']['flag']);
          print(que['student_score_percent']['score']);
          print(que['class_percent']['score']);

          
           _questionData.add(QuestionAnswer(
             studPerc: que['student_score_percent']['score'].toString(),
             classPerc: que['class_percent']['score'].toString() ,
             question: que['question'].toString(),
             questType: que['type'].toString(),
             rightAnswer: que['right_answer']['tag'].toString(),
             studAnswer:que['student_response']['score'].toString(),
             maxScore:que['question_mark'].toString(),
             studScore: que['actual_score'].toString(),
             trueOrfalse: que['correct_answer']['flag'].toString()
           ));
        });
        // print(resp['data']['details']['response']['studentAverageHighest'][0]
        //     .length);
        // print(resp['data']['details']['response']['studentAverageHighest'][1]
        //     .length);
        // print(
        //     resp['data']['details']['response']['studentAverageHighest'][0][1]);
        // print(
        //     resp['data']['details']['response']['studentAverageHighest'][1][0]);
        // print(resp['data']['details']['response']['studentAverageHighest'][1][0]
        //     .runtimeType);
        // print(
        //     resp['data']['details']['response']['studentAverageHighest'][1][1]);
        // print(resp['data']['details']['response']['studentAverageHighest'][1][1]
        //     .runtimeType);

        _chData = [
          ChartData(
              xaxis: resp['data']['details']['response']
                  ['studentAverageHighest'][1][0],
              yaxis:(resp['data']['details']['response']
              ['studentAverageHighest'][1][1]==0)? 0.0: resp['data']['details']['response']
                  ['studentAverageHighest'][1][1],
              colr: ColorUtil.green),
          ChartData(
              xaxis: resp['data']['details']['response']
                  ['studentAverageHighest'][2][0],
              yaxis:(resp['data']['details']['response']
              ['studentAverageHighest'][2][1]==0)?0.0: resp['data']['details']['response']
                  ['studentAverageHighest'][2][1],
              colr: ColorUtil.eventYellow),
          ChartData(
              xaxis: resp['data']['details']['response']
                  ['studentAverageHighest'][3][0],
              yaxis:(resp['data']['details']['response']
              ['studentAverageHighest'][3][1]==0)?0.0: resp['data']['details']['response']
                  ['studentAverageHighest'][3][1],
              colr: ColorUtil.green),
        ];
        print(_chData.length);
        for(int i =0; i<resp['data']['details']['response']['studentAndBatcAvgPerTheme'].length;i++){
          if(i==0){
            continue;
          }
          // print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][0]);
          // print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][0].runtimeType);
          // print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][1]);
          // print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][1].runtimeType);
          // print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][2]);
          // print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][2].runtimeType);
          _compData.add(ComparisonChart(
            xaxis: resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][0],
            y1:double.parse(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][1].toString()),
            y2: double.parse(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][2].toString())
          ));
        }
        print('length of compdata------->${_compData.length}');
        print(resp['data']['details']['response']['tm_elapsed'].length);
        for(int i =0; i<resp['data']['details']['response']['tm_elapsed'].length;i++){
          if(i==0){
            continue;
          }
          // print(resp['data']['details']['response']['tm_elapsed'][i][0]);
          // print(resp['data']['details']['response']['tm_elapsed'][i][1]);
          // print(resp['data']['details']['response']['tm_elapsed'][i][2]);
          // print(resp['data']['details']['response']['tm_elapsed'][i][2].runtimeType);
          // print(resp['data']['details']['response']['tm_elapsed'][i][2].toString().split(':')[1].trim().trim().substring(1,7));
          // print('0xFF${resp['data']['details']['response']['tm_elapsed'][i][2].toString().split(':')[1].trim().substring(1,7)}');
          _timeElapsed.add(ChartData(
            xaxis: resp['data']['details']['response']['tm_elapsed'][i][0],
            yaxis: (resp['data']['details']['response']['tm_elapsed'][i][1] == 0)? 0.0 :resp['data']['details']['response']['tm_elapsed'][i][1],
            colr: ((resp['data']['details']['response']['tm_elapsed'][i][2]=='')||(resp['data']['details']['response']['tm_elapsed'][i][2]==null))? Colors.blue:Color(int.parse('0xFF${resp['data']['details']['response']['tm_elapsed'][i][2].toString().split(':')[1].trim().substring(1,7)}'))
            //colr: Colors.green
          ));
         // print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][0].runtimeType);
          //print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][2]);
          //print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][2].runtimeType);
          // print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][3]);
          // print(resp['data']['details']['response']['studentAndBatcAvgPerTheme'][i][3].runtimeType);

        }
        print('length of time elapsed------->${_timeElapsed.length}');
        //print(resp['data']['details']['response']['studentAndBatcAvgPerTheme']);
        //print(resp['data']['details']['response']['studentAverageHighest']);

        //print('hall ticket length---->${htData.data!.htData!.length}');
        //print('hall ticket runtype---->${htData.data!.htData!.runtimeType}');
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  List<String> dropDown = <String>[
    'Analysis',
    'Score Comparison',
    'Topic Analysis',
    'Activity Report',
  ];
  String dropdownvalue = 'Analysis';
  var _selection = 'Analysis';
  @override
  void initState() {
    _getAFLReport(widget.studId!, widget.qpId!, widget.schlId!);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 1.sw,
            height: 1.sh,
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
                      style: TextStyle(fontSize: 24.sp, color: ColorUtil.white),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.score!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Axiforma",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
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
                                        widget.nos!,
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
                                  border: Border.all(color: ColorUtil.greybg),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.nos!,
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
                          GestureDetector(
                            onTap: (){
                              setState((){
                                _selection = 'Remarks';
                              });

                            },
                            child: Container(
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image(
                                      image:
                                          AssetImage('assets/images/remark.png')),
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
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 1.sw / 2 - 40,
                              height: 6,
                              decoration: BoxDecoration(
                                  color:(_selection == 'Remarks')? ColorUtil.tabIndicator:ColorUtil.white,
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
                          GestureDetector(
                            onTap: (){
                              setState((){
                               // dropdownvalue = 'Question';
                                _selection = 'Question';

                              });
                            },
                            child: Container(
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/images/question.png')),
                                  Text('Question Analysis'),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 1.sw / 2 - 40,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: (_selection == 'Question')?ColorUtil.tabIndicator:ColorUtil.white,
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                            Image(
                                image:
                                    AssetImage('assets/images/analysis.png')),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  elevation: 0,
                                  value: dropdownvalue,
                                  style: const TextStyle(
                                      color: const Color(0xff707071),
                                      fontWeight: FontWeight.w400,
                                      //fontFamily: "Axiforma",
                                      //fontStyle:  FontStyle.normal,
                                      fontSize: 13),
                                  items: dropDown
                                      .map((menu) => DropdownMenuItem<String>(
                                          value: menu,
                                          child: SizedBox(
                                              width: 80,
                                              child: Text(
                                                menu,
                                                maxLines: 2,
                                              ))))
                                      .toList(),
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      dropdownvalue = value!;
                                      // print(dropdownvalue);
                                      _selection = value;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            //top: 40,
            bottom: 0,
            child: Container(
              width: 1.sw,
              height: 1.sh - 260,
             // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 25),
             // margin: EdgeInsets.symmetric(vertical: 20),
              // color: Colors.red,
              child: _isloading
                  ? ListView.builder(
                  itemCount: 4, itemBuilder: (ctx, _) => skeleton)
                  :ListView(
                children: [
                  (_selection == 'Question')?Text('Question Analysis'):(_selection == 'Remarks')? Text('Remarks') : Text('Analysis'),
                  SizedBox(
                    height: 15,
                  ),
                  ...mainTree(_selection)
                  //  Container(
                  //         width: 1.sw,
                  //         height: 250,
                  //    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  //         padding: EdgeInsets.symmetric(horizontal: 10),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.all(Radius.circular(10)),
                  //           boxShadow: [
                  //             BoxShadow(
                  //                 color: const Color(0x78aeaed8),
                  //                 offset: Offset(0, 10),
                  //                 blurRadius: 32,
                  //                 spreadRadius: 0)
                  //           ],
                  //           color: Colors.white,
                  //         ),
                  //         child: SfCartesianChart(
                  //           // palette: <Color>[
                  //           //   Colors.teal,
                  //           //   Colors.orange,
                  //           //   Colors.brown
                  //           // ],
                  //
                  //           title: ChartTitle(
                  //               text: 'Score Comparison',
                  //               alignment: ChartAlignment.near,
                  //               textStyle: TextStyle(
                  //                 fontFamily: 'Axiforma',
                  //                 color: Color(0xff090909),
                  //                 fontSize: 13.sp,
                  //                 fontWeight: FontWeight.w700,
                  //                 fontStyle: FontStyle.normal,
                  //               )),
                  //           primaryXAxis: CategoryAxis(),
                  //           primaryYAxis: NumericAxis(
                  //               minimum: 0, maximum: 100, interval: 25),
                  //           tooltipBehavior: TooltipBehavior(enable: true,),
                  //           series: <ChartSeries<ChartData, String>>[
                  //             ColumnSeries<ChartData, String>(
                  //               width: 0.4,
                  //               dataSource: _chData,
                  //               xValueMapper: (ChartData data, _) => data.xaxis,
                  //               yValueMapper: (ChartData data, _) => data.yaxis,
                  //               name: 'Average',
                  //               // color: Color.fromRGBO(8, 142, 255, 1),
                  //               pointColorMapper: (ChartData data, _) =>
                  //                   data.colr,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  // Container(
                  //   width: 1.sw,
                  //   height: 250,
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     boxShadow: [
                  //       BoxShadow(
                  //           color: const Color(0x78aeaed8),
                  //           offset: Offset(0, 10),
                  //           blurRadius: 32,
                  //           spreadRadius: 0)
                  //     ],
                  //     color: Colors.white,
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           SizedBox(width: 20,),
                  //           Text('Student Vs Theme Average',style: TextStyle(
                  //             fontFamily: 'Axiforma',
                  //             color: Color(0xff090909),
                  //             fontSize: 14.sp,
                  //             fontWeight: FontWeight.w700,
                  //             fontStyle: FontStyle.normal,
                  //           ),),
                  //         ],
                  //       ),
                  //       Container(width: 1.sw,child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: [
                  //           SizedBox(width: 5,),
                  //           Container(width: 30,height: 20,color: Colors.blue,),
                  //           Text('Student Avg'),
                  //           SizedBox(width: 25,),
                  //           Container(width: 30,height: 20,color: Colors.red,),
                  //           Text('Class Avg'),
                  //            SizedBox(width: 50,),
                  //
                  //         ],
                  //       ),),
                  //
                  //       SizedBox(
                  //         height: 200,
                  //         child: SfCartesianChart(
                  //
                  //           palette: <Color>[
                  //             Colors.blue,
                  //             Colors.red,
                  //
                  //           ],
                  //          zoomPanBehavior: ZoomPanBehavior(
                  //           enablePanning: true,
                  //         ),
                  //           // title: ChartTitle(
                  //           //     text: 'Student Vs Theme Average',
                  //           //     alignment: ChartAlignment.near,
                  //           //     textStyle: TextStyle(
                  //           //       fontFamily: 'Axiforma',
                  //           //       color: Color(0xff090909),
                  //           //       fontSize: 12,
                  //           //       fontWeight: FontWeight.w500,
                  //           //       fontStyle: FontStyle.normal,
                  //           //     )),
                  //           primaryXAxis: CategoryAxis(
                  //              visibleMinimum: 0,
                  //             visibleMaximum: 0.28
                  //           ),
                  //           primaryYAxis: NumericAxis(
                  //               minimum: 0, maximum: 100, interval: 20,),
                  //           tooltipBehavior: TooltipBehavior(enable: true),
                  //           series: <ChartSeries<ComparisonChart, String>>[
                  //             ColumnSeries<ComparisonChart, String>(
                  //
                  //               width: 0.5,
                  //               dataSource: _compData,
                  //               xValueMapper: (ComparisonChart data, _) => data.xaxis,
                  //               yValueMapper: (ComparisonChart data, _) => data.y1,
                  //              name: 'Average',
                  //               // color: Color.fromRGBO(8, 142, 255, 1),
                  //               // pointColorMapper: (ChartData data, _) =>
                  //               // data.colr,
                  //             ),
                  //             ColumnSeries<ComparisonChart, String>(
                  //               width: 0.5,
                  //               dataSource: _compData,
                  //               xValueMapper: (ComparisonChart data, _) => data.xaxis,
                  //               yValueMapper: (ComparisonChart data, _) => data.y2,
                  //               //name: 'Gold',
                  //               // color: Color.fromRGBO(8, 142, 255, 1),
                  //               // pointColorMapper: (ChartData data, _) =>
                  //               // data.colr,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   width: 1.sw,
                  //   height: 250,
                  //   margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     boxShadow: [
                  //       BoxShadow(
                  //           color: const Color(0x78aeaed8),
                  //           offset: Offset(0, 10),
                  //           blurRadius: 32,
                  //           spreadRadius: 0)
                  //     ],
                  //     color: Colors.white,
                  //   ),
                  //   child: SfCartesianChart(
                  //     // palette: <Color>[
                  //     //   Colors.teal,
                  //     //   Colors.orange,
                  //     //   Colors.brown
                  //     // ],
                  //
                  //     title: ChartTitle(
                  //         text: 'Activity Report: Time Elapsed',
                  //         alignment: ChartAlignment.near,
                  //         textStyle: TextStyle(
                  //           fontFamily: 'Axiforma',
                  //           color: Color(0xff090909),
                  //           fontSize: 13.sp,
                  //           fontWeight: FontWeight.w700,
                  //           fontStyle: FontStyle.normal,
                  //         )),
                  //     zoomPanBehavior: ZoomPanBehavior(
                  //       enablePanning: true,
                  //     ),
                  //     primaryXAxis: CategoryAxis(
                  //         visibleMinimum: 0,
                  //         visibleMaximum: 5,
                  //        title: AxisTitle(text: 'Questions',textStyle: TextStyle(fontSize: 10.sp))
                  //        // labelIntersectAction: AxisLabelIntersectAction.multipleRows
                  //     ),
                  //     primaryYAxis: NumericAxis(
                  //         minimum: 0, maximum: 4, interval: 1,title: AxisTitle(text: 'Time Elapsed For The Student',textStyle: TextStyle(fontSize: 10.sp))),
                  //     tooltipBehavior: TooltipBehavior(enable: true,),
                  //     series: <ChartSeries<ChartData, String>>[
                  //       LineSeries(  dataSource: _timeElapsed,
                  //         xValueMapper: (ChartData data, _) => data.xaxis,
                  //         yValueMapper: (ChartData data, _) => data.yaxis,),
                  //       ColumnSeries<ChartData, String>(
                  //         width: 0.4,
                  //         dataSource: _timeElapsed,
                  //         xValueMapper: (ChartData data, _) => data.xaxis,
                  //         yValueMapper: (ChartData data, _) => data.yaxis,
                  //         name: 'Time',
                  //         // color: Color.fromRGBO(8, 142, 255, 1),
                  //         pointColorMapper: (ChartData data, _) =>
                  //         data.colr,
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                  // QuestionAnalysis()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  List<Widget> mainTree(String type){
    switch(type){
       case 'Analysis':
        return [
          Container(
            width: 1.sw,
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x78aeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0)
              ],
              color: Colors.white,
            ),
            child: SfCartesianChart(
              // palette: <Color>[
              //   Colors.teal,
              //   Colors.orange,
              //   Colors.brown
              // ],

              title: ChartTitle(
                  text: 'Score Comparison',
                  alignment: ChartAlignment.near,
                  textStyle: TextStyle(
                    fontFamily: 'Axiforma',
                    color: Color(0xff090909),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  )),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                  minimum: 0, maximum: 100, interval: 25),
              tooltipBehavior: TooltipBehavior(enable: true,),
              series: <ChartSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  width: 0.4,
                  dataSource: _chData,
                  xValueMapper: (ChartData data, _) => data.xaxis,
                  yValueMapper: (ChartData data, _) => data.yaxis,
                  name: 'Average',
                  // color: Color.fromRGBO(8, 142, 255, 1),
                  pointColorMapper: (ChartData data, _) =>
                  data.colr,
                ),
              ],
            ),
          ),
          Container(
            width: 1.sw,
            height: 250,
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x78aeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0)
              ],
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text('Student Vs Theme Average',style: TextStyle(
                      fontFamily: 'Axiforma',
                      color: Color(0xff090909),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),),
                  ],
                ),
                Container(width: 1.sw,child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 5,),
                    Container(width: 30,height: 20,color: Colors.blue,),
                    Text('Student Avg'),
                    SizedBox(width: 25,),
                    Container(width: 30,height: 20,color: Colors.red,),
                    Text('Class Avg'),
                    SizedBox(width: 50,),

                  ],
                ),),

                SizedBox(
                  height: 200,
                  child: SfCartesianChart(

                    palette: <Color>[
                      Colors.blue,
                      Colors.red,

                    ],
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true,
                    ),
                    // title: ChartTitle(
                    //     text: 'Student Vs Theme Average',
                    //     alignment: ChartAlignment.near,
                    //     textStyle: TextStyle(
                    //       fontFamily: 'Axiforma',
                    //       color: Color(0xff090909),
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //       fontStyle: FontStyle.normal,
                    //     )),
                    primaryXAxis: CategoryAxis(
                        visibleMinimum: 0,
                        visibleMaximum: 0.28
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0, maximum: 100, interval: 20,),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<ComparisonChart, String>>[
                      ColumnSeries<ComparisonChart, String>(

                        width: 0.5,
                        dataSource: _compData,
                        xValueMapper: (ComparisonChart data, _) => data.xaxis,
                        yValueMapper: (ComparisonChart data, _) => data.y1,
                        name: 'Average',
                        // color: Color.fromRGBO(8, 142, 255, 1),
                        // pointColorMapper: (ChartData data, _) =>
                        // data.colr,
                      ),
                      ColumnSeries<ComparisonChart, String>(
                        width: 0.5,
                        dataSource: _compData,
                        xValueMapper: (ComparisonChart data, _) => data.xaxis,
                        yValueMapper: (ComparisonChart data, _) => data.y2,
                        //name: 'Gold',
                        // color: Color.fromRGBO(8, 142, 255, 1),
                        // pointColorMapper: (ChartData data, _) =>
                        // data.colr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1.sw,
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x78aeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0)
              ],
              color: Colors.white,
            ),
            child: SfCartesianChart(
              // palette: <Color>[
              //   Colors.teal,
              //   Colors.orange,
              //   Colors.brown
              // ],

              title: ChartTitle(
                  text: 'Activity Report: Time Elapsed',
                  alignment: ChartAlignment.near,
                  textStyle: TextStyle(
                    fontFamily: 'Axiforma',
                    color: Color(0xff090909),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  )),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
              ),
              primaryXAxis: CategoryAxis(
                  visibleMinimum: 0,
                  visibleMaximum: 5,
                  title: AxisTitle(text: 'Questions',textStyle: TextStyle(fontSize: 10.sp))
                // labelIntersectAction: AxisLabelIntersectAction.multipleRows
              ),
              primaryYAxis: NumericAxis(
                  minimum: 0, maximum: 4, interval: 1,title: AxisTitle(text: 'Time Elapsed For The Student',textStyle: TextStyle(fontSize: 10.sp))),
              tooltipBehavior: TooltipBehavior(enable: true,),
              series: <ChartSeries<ChartData, String>>[
                LineSeries(  dataSource: _timeElapsed,
                  xValueMapper: (ChartData data, _) => data.xaxis,
                  yValueMapper: (ChartData data, _) => data.yaxis,),
                ColumnSeries<ChartData, String>(
                  width: 0.4,
                  dataSource: _timeElapsed,
                  xValueMapper: (ChartData data, _) => data.xaxis,
                  yValueMapper: (ChartData data, _) => data.yaxis,
                  name: 'Time',
                  // color: Color.fromRGBO(8, 142, 255, 1),
                  pointColorMapper: (ChartData data, _) =>
                  data.colr,
                ),

              ],
            ),
          ),
          ..._questionData.map((quest) => QuestionAnalysis(question: quest.question,questType: quest.questType,studScore: quest.studScore,studAnswer: quest.studAnswer,maxScore: quest.maxScore,rightAnswer: quest.rightAnswer,torf: quest.trueOrfalse,studPerc: quest.studPerc,maxPerc: quest.classPerc,)).toList(),
        ];
        //break;
        case 'Score Comparison':
         return [
           Container(
             width: 1.sw,
             height: 250,
             margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
             padding: EdgeInsets.symmetric(horizontal: 10),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.all(Radius.circular(10)),
               boxShadow: [
                 BoxShadow(
                     color: const Color(0x78aeaed8),
                     offset: Offset(0, 10),
                     blurRadius: 32,
                     spreadRadius: 0)
               ],
               color: Colors.white,
             ),
             child: SfCartesianChart(
               // palette: <Color>[
               //   Colors.teal,
               //   Colors.orange,
               //   Colors.brown
               // ],

               title: ChartTitle(
                   text: 'Score Comparison',
                   alignment: ChartAlignment.near,
                   textStyle: TextStyle(
                     fontFamily: 'Axiforma',
                     color: Color(0xff090909),
                     fontSize: 13.sp,
                     fontWeight: FontWeight.w700,
                     fontStyle: FontStyle.normal,
                   )),
               primaryXAxis: CategoryAxis(),
               primaryYAxis: NumericAxis(
                   minimum: 0, maximum: 100, interval: 25),
               tooltipBehavior: TooltipBehavior(enable: true,),
               series: <ChartSeries<ChartData, String>>[
                 ColumnSeries<ChartData, String>(
                   width: 0.4,
                   dataSource: _chData,
                   xValueMapper: (ChartData data, _) => data.xaxis,
                   yValueMapper: (ChartData data, _) => data.yaxis,
                   name: 'Average',
                   // color: Color.fromRGBO(8, 142, 255, 1),
                   pointColorMapper: (ChartData data, _) =>
                   data.colr,
                 ),
               ],
             ),
           ),
         ];
      case 'Topic Analysis':
        return [
        Container(
          width: 1.sw,
          height: 250,
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x78aeaed8),
                  offset: Offset(0, 10),
                  blurRadius: 32,
                  spreadRadius: 0)
            ],
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('Student Vs Theme Average',style: TextStyle(
                    fontFamily: 'Axiforma',
                    color: Color(0xff090909),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),),
                ],
              ),
              Container(width: 1.sw,child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 5,),
                  Container(width: 30,height: 20,color: Colors.blue,),
                  Text('Student Avg'),
                  SizedBox(width: 25,),
                  Container(width: 30,height: 20,color: Colors.red,),
                  Text('Class Avg'),
                  SizedBox(width: 50,),

                ],
              ),),

              SizedBox(
                height: 200,
                child: SfCartesianChart(

                  palette: <Color>[
                    Colors.blue,
                    Colors.red,

                  ],
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                  ),
                  // title: ChartTitle(
                  //     text: 'Student Vs Theme Average',
                  //     alignment: ChartAlignment.near,
                  //     textStyle: TextStyle(
                  //       fontFamily: 'Axiforma',
                  //       color: Color(0xff090909),
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w500,
                  //       fontStyle: FontStyle.normal,
                  //     )),
                  primaryXAxis: CategoryAxis(
                      visibleMinimum: 0,
                      visibleMaximum: 0.28
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 0, maximum: 100, interval: 20,),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<ComparisonChart, String>>[
                    ColumnSeries<ComparisonChart, String>(

                      width: 0.5,
                      dataSource: _compData,
                      xValueMapper: (ComparisonChart data, _) => data.xaxis,
                      yValueMapper: (ComparisonChart data, _) => data.y1,
                      name: 'Average',
                      // color: Color.fromRGBO(8, 142, 255, 1),
                      // pointColorMapper: (ChartData data, _) =>
                      // data.colr,
                    ),
                    ColumnSeries<ComparisonChart, String>(
                      width: 0.5,
                      dataSource: _compData,
                      xValueMapper: (ComparisonChart data, _) => data.xaxis,
                      yValueMapper: (ComparisonChart data, _) => data.y2,
                      //name: 'Gold',
                      // color: Color.fromRGBO(8, 142, 255, 1),
                      // pointColorMapper: (ChartData data, _) =>
                      // data.colr,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ];
      case 'Activity Report':
        return [
          Container(
            width: 1.sw,
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x78aeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0)
              ],
              color: Colors.white,
            ),
            child: SfCartesianChart(
              // palette: <Color>[
              //   Colors.teal,
              //   Colors.orange,
              //   Colors.brown
              // ],

              title: ChartTitle(
                  text: 'Activity Report: Time Elapsed',
                  alignment: ChartAlignment.near,
                  textStyle: TextStyle(
                    fontFamily: 'Axiforma',
                    color: Color(0xff090909),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  )),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
              ),
              primaryXAxis: CategoryAxis(
                  visibleMinimum: 0,
                  visibleMaximum: 5,
                  title: AxisTitle(text: 'Questions',textStyle: TextStyle(fontSize: 10.sp))
                // labelIntersectAction: AxisLabelIntersectAction.multipleRows
              ),
              primaryYAxis: NumericAxis(
                  minimum: 0, maximum: 4, interval: 1,title: AxisTitle(text: 'Time Elapsed For The Student',textStyle: TextStyle(fontSize: 10.sp))),
              tooltipBehavior: TooltipBehavior(enable: true,),
              series: <ChartSeries<ChartData, String>>[
                LineSeries(  dataSource: _timeElapsed,
                  xValueMapper: (ChartData data, _) => data.xaxis,
                  yValueMapper: (ChartData data, _) => data.yaxis,),
                ColumnSeries<ChartData, String>(
                  width: 0.4,
                  dataSource: _timeElapsed,
                  xValueMapper: (ChartData data, _) => data.xaxis,
                  yValueMapper: (ChartData data, _) => data.yaxis,
                  name: 'Time',
                  // color: Color.fromRGBO(8, 142, 255, 1),
                  pointColorMapper: (ChartData data, _) =>
                  data.colr,
                ),

              ],
            ),
          ),
        ];
      case 'Question':
        return [
          //QuestionAnalysis(),

          ..._questionData.map((quest) => QuestionAnalysis(question: quest.question,questType: quest.questType,studScore: quest.studScore,studAnswer: quest.studAnswer,maxScore: quest.maxScore,rightAnswer: quest.rightAnswer,torf: quest.trueOrfalse,studPerc: quest.studPerc,maxPerc: quest.classPerc,)).toList(),
        ];
      case 'Remarks':
        return [
         AFLRemark(remedial: _remedial.toString()),
        ];
      default:
        return [
          Container(
            width: 1.sw,
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x78aeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0)
              ],
              color: Colors.white,
            ),
            child: SfCartesianChart(
              // palette: <Color>[
              //   Colors.teal,
              //   Colors.orange,
              //   Colors.brown
              // ],

              title: ChartTitle(
                  text: 'Score Comparison',
                  alignment: ChartAlignment.near,
                  textStyle: TextStyle(
                    fontFamily: 'Axiforma',
                    color: Color(0xff090909),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  )),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                  minimum: 0, maximum: 100, interval: 25),
              tooltipBehavior: TooltipBehavior(enable: true,),
              series: <ChartSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  width: 0.4,
                  dataSource: _chData,
                  xValueMapper: (ChartData data, _) => data.xaxis,
                  yValueMapper: (ChartData data, _) => data.yaxis,
                  name: 'Average',
                  // color: Color.fromRGBO(8, 142, 255, 1),
                  pointColorMapper: (ChartData data, _) =>
                  data.colr,
                ),
              ],
            ),
          ),
          Container(
            width: 1.sw,
            height: 250,
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x78aeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0)
              ],
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text('Student Vs Theme Average',style: TextStyle(
                      fontFamily: 'Axiforma',
                      color: Color(0xff090909),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),),
                  ],
                ),
                Container(width: 1.sw,child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 5,),
                    Container(width: 30,height: 20,color: Colors.blue,),
                    Text('Student Avg'),
                    SizedBox(width: 25,),
                    Container(width: 30,height: 20,color: Colors.red,),
                    Text('Class Avg'),
                    SizedBox(width: 50,),

                  ],
                ),),

                SizedBox(
                  height: 200,
                  child: SfCartesianChart(

                    palette: <Color>[
                      Colors.blue,
                      Colors.red,

                    ],
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true,
                    ),
                    // title: ChartTitle(
                    //     text: 'Student Vs Theme Average',
                    //     alignment: ChartAlignment.near,
                    //     textStyle: TextStyle(
                    //       fontFamily: 'Axiforma',
                    //       color: Color(0xff090909),
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //       fontStyle: FontStyle.normal,
                    //     )),
                    primaryXAxis: CategoryAxis(
                        visibleMinimum: 0,
                        visibleMaximum: 0.28
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0, maximum: 100, interval: 20,),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<ComparisonChart, String>>[
                      ColumnSeries<ComparisonChart, String>(

                        width: 0.5,
                        dataSource: _compData,
                        xValueMapper: (ComparisonChart data, _) => data.xaxis,
                        yValueMapper: (ComparisonChart data, _) => data.y1,
                        name: 'Average',
                        // color: Color.fromRGBO(8, 142, 255, 1),
                        // pointColorMapper: (ChartData data, _) =>
                        // data.colr,
                      ),
                      ColumnSeries<ComparisonChart, String>(
                        width: 0.5,
                        dataSource: _compData,
                        xValueMapper: (ComparisonChart data, _) => data.xaxis,
                        yValueMapper: (ComparisonChart data, _) => data.y2,
                        //name: 'Gold',
                        // color: Color.fromRGBO(8, 142, 255, 1),
                        // pointColorMapper: (ChartData data, _) =>
                        // data.colr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1.sw,
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x78aeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0)
              ],
              color: Colors.white,
            ),
            child: SfCartesianChart(
              // palette: <Color>[
              //   Colors.teal,
              //   Colors.orange,
              //   Colors.brown
              // ],

              title: ChartTitle(
                  text: 'Activity Report: Time Elapsed',
                  alignment: ChartAlignment.near,
                  textStyle: TextStyle(
                    fontFamily: 'Axiforma',
                    color: Color(0xff090909),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  )),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
              ),
              primaryXAxis: CategoryAxis(
                  visibleMinimum: 0,
                  visibleMaximum: 5,
                  title: AxisTitle(text: 'Questions',textStyle: TextStyle(fontSize: 10.sp))
                // labelIntersectAction: AxisLabelIntersectAction.multipleRows
              ),
              primaryYAxis: NumericAxis(
                  minimum: 0, maximum: 4, interval: 1,title: AxisTitle(text: 'Time Elapsed For The Student',textStyle: TextStyle(fontSize: 10.sp))),
              tooltipBehavior: TooltipBehavior(enable: true,),
              series: <ChartSeries<ChartData, String>>[
                LineSeries(  dataSource: _timeElapsed,
                  xValueMapper: (ChartData data, _) => data.xaxis,
                  yValueMapper: (ChartData data, _) => data.yaxis,),
                ColumnSeries<ChartData, String>(
                  width: 0.4,
                  dataSource: _timeElapsed,
                  xValueMapper: (ChartData data, _) => data.xaxis,
                  yValueMapper: (ChartData data, _) => data.yaxis,
                  name: 'Time',
                  // color: Color.fromRGBO(8, 142, 255, 1),
                  pointColorMapper: (ChartData data, _) =>
                  data.colr,
                ),

              ],
            ),
          ),
          ..._questionData.map((quest) => QuestionAnalysis(question: quest.question,questType: quest.questType,studScore: quest.studScore,studAnswer: quest.studAnswer,maxScore: quest.maxScore,rightAnswer: quest.rightAnswer,torf: quest.trueOrfalse,studPerc: quest.studPerc,maxPerc: quest.classPerc,)).toList(),
        ];
    }
  }
}
