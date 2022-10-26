import 'package:flutter/material.dart';

import '../../Models/downloadmodel.dart';
import '../../Services/getfiles.dart';
import '../../Widgets/circulardwnldwidget.dart';
class ExamDownloads extends StatefulWidget {
  const ExamDownloads({Key? key}) : super(key: key);

  @override
  State<ExamDownloads> createState() => _ExamDownloadsState();
}

class _ExamDownloadsState extends State<ExamDownloads> {
  List<DownloadModel> halltkt = [];
  var _isloading = false;
  getHallTkt() async {
    setState((){
      _isloading = true;
    });
    halltkt = await getFiles('HallTicket');
    print(halltkt.length);
    setState((){
      _isloading = false;
    });
  }
  @override
  void initState() {
    getHallTkt();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _isloading ?  Text('No downloads in circular'):ListView.builder(itemBuilder: (ctx,i)=>CircularDwnldWidget(
      filePath: halltkt[i].path,
      title: halltkt[i].title,
      date: halltkt[i].date,
      type: 'HallTicket',
    ),itemCount: halltkt.length,) ;
  }
}
