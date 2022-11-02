import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_diary_sept_13/Screens/AFL_Screen.dart';
import 'package:school_diary_sept_13/Screens/ReportSubScreen/exam_main_screen.dart';
import 'package:school_diary_sept_13/Screens/ReportSubScreen/hall_ticket_screen.dart';
import 'package:school_diary_sept_13/Screens/ReportSubScreen/report_main_screen.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';
import 'package:school_diary_sept_13/Util/spinkit.dart';
import 'package:school_diary_sept_13/Widgets/cat4widget.dart';
import 'package:school_diary_sept_13/Widgets/exam_widget.dart';
import 'package:school_diary_sept_13/Widgets/hallTicketWidget.dart';
import 'package:school_diary_sept_13/Widgets/report_widget.dart';
import '../Models/hallTicket_model.dart';
import '../Models/report_model.dart';
import '../Provider/user_provider.dart';
import '../Models/published_exam_model.dart';

class ReportMainScreen extends StatefulWidget {
  final String? usrId;
  final String? schoolId;
  final String? acadYear;
  final String? curriculumId;
  final String? batchId;
  final String? studId;
  final String? sessionId;
  final String? classId;
  const ReportMainScreen({
    Key? key,
    this.schoolId,
    this.acadYear,
    this.batchId,
    this.classId,
    this.curriculumId,
    this.sessionId,
    this.studId,
    this.usrId,
  }) : super(key: key);

  @override
  State<ReportMainScreen> createState() => _ReportMainScreenState();
}

class _ReportMainScreenState extends State<ReportMainScreen> {
  var selectedTab = 1;
  var _isloading = false;
  var _report = Report();
  var _isAfl = false;
  List<ArrayToClient>? _arrayToclient;
  List<Widget> report = [];
  var reporFrom;
  var published;
  var htData = HtModel();
  List<HallTicketData>? hallTickets = [];
  List<Published> pExams = [];
  var pubExams = Published();
  List<Color> _clrs = [
    ColorUtil.circularBg,
    ColorUtil.examText,
    ColorUtil.eventYellow,
    ColorUtil.subGold
  ];
  _getReport(String schoolId, String childId, String acadYear) async {
    try {
      setState(() {
        reporFrom = [];
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getPublishedReport(schoolId, childId, acadYear);
      // print(resp.runtimeType);
      report.clear();
      print('report card length ---------->${report.length}');
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        print('its working');
        print(resp['data']['details']['arrayToClient']);
        //  _report = Report.fromJson(resp);
        //print(_report.data!.message);
        //_arrayToclient = _report.data!.details!.arrayToClient;
        reporFrom = resp['data']['details']['arrayToClient'];
        //   resp['data']['details']['arrayToClient'].forEach((one){
        //     print(one);
        //   });
        print(reporFrom);
        //   reporFrom.sort((a,b){
        //       DateTime aa = a['last_updated'];
        //       DateTime bb = b['last_updated'];
        //       return -1 * aa.compareTo(bb);
        //   });
        reporFrom.sort((a, b) {
          DateTime aa = DateFormat('yyyy-M-d').parse(a['last_updated']);
          DateTime bb = DateFormat('yyyy-M-d').parse(b['last_updated']);
          return -1 * aa.compareTo(bb);
        });
        reporFrom!.forEach((one) {
          print(one['name']);
          print(one['last_updated']);
          if (one['name'] == 'CAT-4') {
            report.add(CatFour(
              title: one['name'].toString(),
              date: one['last_updated'].toString(),
            ));
          } else if (one['name'] == 'Assets') {
            report.add(CatFour(
              title: one['name'].toString(),
              date: one['last_updated'].toString(),
            ));
          } else {
            report.add(EachReport(
              title: one['name'].toString(),
              date: one['last_updated'].toString(),
              reportConsoleId: one['report_console_id'].toString(),
              studId: widget.studId,
              schoolId: widget.schoolId,
              acdYear: widget.acadYear,
            ));
          }
        });
        //print('length of arr------------->${_arrayToclient!.length}');
        // _arrayToclient!.sort((a,b){
        //   DateTime aa = a.lastUpdated!;
        //   DateTime bb = b.lastUpdated!;
        //   return -1 * aa.compareTo(bb);
        // });
        // _arrayToclient!.forEach((atc) {
        //   report.add(EachReport(
        //     title: atc.name,
        //     date: atc.lastUpdated,
        //   ));
        // });
        // _circularList = Circular.fromJson(resp);
        //print(_circularList.data!.details!.first.title);
        setState(() {
          //_ciculars = _circularList.data!.details!;
        });
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  _getExam(String schoolId, String acadYear, String currId, String batchId,
      String stdId, String sessionId, String clsId) async {
    try {
      setState(() {
       // reporFrom = [];
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getExams(
              schoolId, acadYear, currId, batchId, stdId, sessionId, clsId);
      // print(resp.runtimeType);


      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        print('its working');
        print('-------------->${resp['data']['message']}');
        //print('--------------response----------');
        //print(resp['data']['data']['published_completed']);
        published =  resp['data']['data']['published_completed'];
        if(published == null){
          published = [];
        }
        print('length of exam published --------->${published.length}');
        // print(resp['data']['details']['arrayToClient']);
        // //  _report = Report.fromJson(resp);
        // //print(_report.data!.message);
        // //_arrayToclient = _report.data!.details!.arrayToClient;
        // reporFrom = resp['data']['details']['arrayToClient'];
        // //   resp['data']['details']['arrayToClient'].forEach((one){
        // //     print(one);
        // //   });
        // print(reporFrom);
        // //   reporFrom.sort((a,b){
        // //       DateTime aa = a['last_updated'];
        // //       DateTime bb = b['last_updated'];
        // //       return -1 * aa.compareTo(bb);
        // //   });
        // reporFrom.sort((a,b){
        //   DateTime aa = DateFormat('yyyy-M-d').parse(a['last_updated']);
        //   DateTime bb = DateFormat('yyyy-M-d').parse(b['last_updated']);
        //   return -1 * aa.compareTo(bb);
        // });
        // reporFrom!.forEach((one) {
        //   print(one['name']);
        //   print(one['last_updated']);
        //   report.add(EachReport(
        //     title: one['name'].toString(),
        //     date: one['last_updated'].toString(),
        //   ));
        // });
        //print('length of arr------------->${_arrayToclient!.length}');
        // _arrayToclient!.sort((a,b){
        //   DateTime aa = a.lastUpdated!;
        //   DateTime bb = b.lastUpdated!;
        //   return -1 * aa.compareTo(bb);
        // });
        // _arrayToclient!.forEach((atc) {
        //   report.add(EachReport(
        //     title: atc.name,
        //     date: atc.lastUpdated,
        //   ));
        // });
        // _circularList = Circular.fromJson(resp);
        //print(_circularList.data!.details!.first.title);
        setState(() {
          //_ciculars = _circularList.data!.details!;
        });
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  _getHallTicket(String childId) async {
    try {
      setState(() {

        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getHallticket(childId);
      // print(resp.runtimeType);
      //report.clear();
      hallTickets!.clear();
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });

        htData = HtModel.fromJson(resp);
        hallTickets = htData.data!.htData;
        //print('hall ticket length---->${htData.data!.htData!.length}');
        //print('hall ticket runtype---->${htData.data!.htData!.runtimeType}');
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  void selectedWid(int actIndex) {
    switch (actIndex) {
      case 1:
        _getReport(widget.schoolId!, widget.studId!, widget.acadYear!);
        break;
      case 2:
        _getExam(
            widget.schoolId!,
            widget.acadYear!,
            widget.curriculumId!,
            widget.batchId!,
            widget.studId!,
            widget.sessionId!,
            widget.classId!);
        break;
      case 3:
        _getHallTicket(widget.studId!);
        break;
      default:
        _getReport(widget.schoolId!, widget.studId!, widget.acadYear!);
        ;
    }
  }

  @override
  void didUpdateWidget(covariant ReportMainScreen oldWidget) {
    selectedWid(selectedTab);
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    selectedWid(selectedTab);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return _isAfl? AFLReport() :Column(
      children: [
        Container(
          width: 1.sw,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 15),
          // color: Colors.green,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Row(
            children: [
              tabItem('Reports', 1),
              tabItem('Exams', 2),
              tabItem('HallTickets', 3)
            ],
          ),
        ),
        Container(
          width: 1.sw,
          height: 1.sh - 260,
          color: ColorUtil.bg.withOpacity(0.6),
          child: _isloading
              ? ListView.builder(
                  itemCount: 4, itemBuilder: (ctx, _) => skeleton)
              : (selectedTab == 1)
                  ? report.isNotEmpty
                      ? ListView(
                          addAutomaticKeepAlives: true,
                          children: report,
                        )
                      : Center(child: Text('No Reports Available'))
                  : (selectedTab == 2)
                      ? published.isNotEmpty? ListView.builder(
             itemCount: published.length,
              itemBuilder: (ctx,index) => ExamWidget(
                schlId: widget.schoolId,
                studId: widget.studId,
                qpId: published[index]['_id'],
                color: _clrs[index % 3],
                date: published[index]['due_date'],
                activityName: published[index]['activity_name'],
                subName: published[index]['subject_name'],
                themes: published[index]['theme_names'],
                markObt: published[index]['mark'].toString(),
                maxMark: published[index]['total_mark'].toString(),
              )) : Center(child: Text('No Exams Available'))
                      : (selectedTab == 3)
                          ? hallTickets!.isNotEmpty? ListView.builder(
            itemCount: hallTickets!.length,
              itemBuilder: (ctx,ind)=>HallTicketWidget(url: hallTickets![ind].pdf,date: hallTickets![ind].gneratedOn,title: hallTickets![ind].examName,childId: widget.studId),) : Center(child: Text('No HallTickets Available'))
                          : Text('kk'),
        )
      ],
    );
  }

  Widget tabItem(String tabName, int activeIndex) => InkWell(
        onTap: () {
          setState(() {
            selectedTab = activeIndex;
            selectedWid(selectedTab);
          });
        },
        child: Container(
          width: 1.sw / 3 - 10,
          height: 50,
          //color: Colors.blue,
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Text(
                tabName,
                style: TextStyle(
                    color: selectedTab == activeIndex
                        ? ColorUtil.tabIndicator
                        : ColorUtil.tabIndicator.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                    //fontFamily: "Axiforma",
                    //fontStyle:  FontStyle.normal,
                    fontSize: 14.sp),
              ),
              SizedBox(
                height: 9,
              ),
              selectedTab == activeIndex
                  ? Container(
                      width: 1.sw / 3,
                      height: 5,
                      decoration: BoxDecoration(
                          color: ColorUtil.tabIndicator,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                    )
                  : Container()
            ],
          ),
        ),
      );
}
