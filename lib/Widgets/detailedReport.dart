import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';

class DetailedReport extends StatefulWidget {
  final List<String>? subjects;
  final Map<String, dynamic>? detailedList;
  const DetailedReport({Key? key, this.subjects, this.detailedList})
      : super(key: key);

  @override
  State<DetailedReport> createState() => _DetailedReportState();
}

class _DetailedReportState extends State<DetailedReport> {
  String markObtained(String keyy) {
    if (widget.detailedList!.containsKey(keyy)) {
      //print('OK');
      //print(keyy);
      return widget.detailedList![keyy]['total_mark'].toString();
    } else {
      return ' ';
    }
  }

  String maxMark(String keyy) {
    if (widget.detailedList!.containsKey(keyy)) {
      //print('OK');
      //print(keyy);
      return widget.detailedList![keyy]['out_of_mark'].toString();
    } else {
      return ' ';
    }
  }

  String grade(String keyy) {
    if (widget.detailedList!.containsKey(keyy)) {
      //print('OK');
      //print(keyy);
      if(widget.detailedList![keyy]['grade']!=null){
        return widget.detailedList![keyy]['grade'].toString();
      }else{
        return 'NA';
      }

    } else {
      return ' ';
    }
  }

  List<Color> _colors = [
    ColorUtil.circularRed,
    ColorUtil.green,
    ColorUtil.subBlue,
    ColorUtil.subGold
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 40 * double.parse(widget.subjects!.length.toString()) + 130,
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Table(
            border: TableBorder(horizontalInside: BorderSide(width: 1,color: ColorUtil.totalDaysIndicator.withOpacity(0.5))),
            columnWidths: {
              0: FlexColumnWidth(3.5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
            },
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Subject',
                    style: tableHeaderStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Mark',
                      textAlign: TextAlign.center,
                    style: tableHeaderStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total',
                      textAlign: TextAlign.center,
                    style: tableHeaderStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Grade',
                      textAlign: TextAlign.center,
                    style: tableHeaderStyle(),
                  ),
                )
              ]),

              ...widget.subjects!
                  .asMap()
                  .map((index, element) => MapEntry(
                      index,
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(element,style: tableElementStyle(index),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(markObtained(element),style: tableElementStyle(index),textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(maxMark(element),style: tableElementStyle(index),textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(grade(element),style: tableElementStyle(index),textAlign: TextAlign.center,),
                        )
                      ])))
                  .values
                  .toList()
            ],
          ),
          //SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Icon(Icons.cloud_download_outlined,color: ColorUtil.downloadClr,),
                Text('Download File', style: TextStyle(
                  fontFamily: 'Axiforma',
                  color: ColorUtil.downloadClr,
                  fontSize: 7,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,


                ),)
              ],
            ),
          )
        ],
        
      ),
    );
  }

  tableHeaderStyle() => TextStyle(
      color: ColorUtil.totalDaysIndicator,
      fontWeight: FontWeight.w400,
      //fontFamily: "Axiforma",
      //fontStyle:  FontStyle.normal,
      fontSize: 12.sp);
  tableElementStyle(int index) => TextStyle(
      color: (index>=4)? _colors[index%4] : _colors[index],
      fontWeight: FontWeight.w400,
      //fontFamily: "Axiforma",
      //fontStyle:  FontStyle.normal,
      fontSize: 12.sp);
}
