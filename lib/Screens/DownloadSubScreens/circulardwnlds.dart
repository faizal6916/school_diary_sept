import 'package:flutter/material.dart';
import 'package:school_diary_sept_13/Models/downloadmodel.dart';
import 'package:school_diary_sept_13/Services/getfiles.dart';
import '../../Widgets/circulardwnldwidget.dart';
class CircularDownloads extends StatefulWidget {
  const CircularDownloads({Key? key}) : super(key: key);

  @override
  State<CircularDownloads> createState() => _CircularDownloadsState();
}

class _CircularDownloadsState extends State<CircularDownloads> {
  List<DownloadModel> circlars = [];
  var _isloading = false;
  getCirc() async {
    setState((){
      _isloading = true;
    });
    circlars = await getFiles('Circular');
    print(circlars.length);
    setState((){
      _isloading = false;
    });
  }
  @override
  void initState() {
    getCirc();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _isloading ?  Text('No downloads in circular'):ListView.builder(itemBuilder: (ctx,i)=>CircularDwnldWidget(
filePath: circlars[i].path,
      title: circlars[i].title,
      date: circlars[i].date,
      type: 'Circular',
    ),itemCount: circlars.length,) ;
  }
}
