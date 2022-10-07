import 'dart:io';
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:open_file_safe/open_file_safe.dart';

import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:school_diary_sept_13/Util/api_constants.dart';
import 'package:school_diary_sept_13/Widgets/attachment_widget.dart';

import '../Util/color_util.dart';
import '../Models/circular_model.dart';

class CircularWidget extends StatefulWidget {
  final String? childId;
  final DateTime? circularDate;
  final String? cicularTitle;
  final String? circularDesc;
  final String? senderName;
  final List<String>? attachment;
  const CircularWidget(
      {Key? key,
      this.childId,
      this.circularDate,
      this.cicularTitle,
      this.circularDesc,
      this.senderName,
      this.attachment})
      : super(key: key);

  @override
  State<CircularWidget> createState() => _CircularWidgetState();
}

class _CircularWidgetState extends State<CircularWidget> {

  // Future openFile({required String url,String? filename}) async {
  //   final file =await downloadFile(url,filename!);
  //   if (file == null) return;
  //   print('Path:${file.path}');
  //
  //   OpenFile.open(file.path);
  // }
  // Future<File?> downloadFile(String url,String filename) async{
  //   //final appStorage = await getApplicationDocumentsDirectory();
  //   if(await Permission.storage.request().isGranted){
  //     final path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  //     var dir = await Directory('$path/SchoolDiary/Circular');
  //     var file = File('/');
  //     if(await dir.exists()){
  //        file = File('${dir.path}/$filename');
  //     }else{
  //       var dir = await Directory('$path/SchoolDiary/Circular').create(recursive: true);
  //        file = File('${dir.path}/$filename');
  //     }
  //     try{
  //       final response = await Dio().get(url,options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           receiveTimeout: 0,
  //
  //       ),onReceiveProgress: (rec,total){
  //         setState((){
  //           _isDownloading = true;
  //           progressPer = rec/total;
  //           progressStr = ((rec/total)*100).toStringAsFixed(0);
  //         });
  //       } );
  //
  //       final raf = file.openSync(mode: FileMode.write);
  //       raf.writeFromSync(response.data);
  //       await raf.close();
  //       setState((){
  //         _isDownloading = false;
  //         _isDownloaded = true;
  //       });
  //       return file;
  //
  //     }catch(e){
  //       print(e);
  //       return null;
  //     }
  //   }
  //
  //
  // }
  DateFormat _examformatter = DateFormat('dd MMMM');
  var _isOpen = false;
  // var _isDownloading = false;
  // var _isDownloaded = false;
  // var progressStr = "";
  // var progressPer = 0.0;
  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isOpen = !_isOpen;
              });
            },
            child: Container(
              width: 1.sw,
              height: 100,
              padding: EdgeInsets.all(15),
              // margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  // border: Border(bottom: BorderSide(width: 1,color: ColorUtil.borderSep.withOpacity(0.1))),
                  // borderRadius: BorderRadius.only(
                  //     topRight: Radius.circular(10),
                  //     topLeft: Radius.circular(10)),
                  borderRadius: _isOpen
                      ? BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))
                      : BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x1f324dab),
                        offset: Offset(0, 32),
                        blurRadius: 22,
                        spreadRadius: -8)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment(0.5, -3),
                      end: Alignment(0.5, 1),
                      colors: [Colors.white, const Color(0xfff8f9ff)])),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      color: ColorUtil.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                        child: Text(
                      _examformatter.format(widget.circularDate!),
                      style: TextStyle(color: ColorUtil.white, fontSize: 12.sp),
                    )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 1.sw - 170,
                    height: 50,
                    child: AutoSizeText(
                      widget.cicularTitle!,
                      maxLines: 2,
                      style: TextStyle(
                          color: ColorUtil.blue, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    _isOpen
                        ? Icons.arrow_drop_up_outlined
                        : Icons.arrow_drop_down_outlined,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 1.sw,
            height: _isOpen ? 100 + widget.attachment!.length * 20 : 0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x1f324dab),
                      offset: Offset(0, 32),
                      blurRadius: 22,
                      spreadRadius: -8)
                ],
                gradient: LinearGradient(
                    begin: Alignment(0.5, -3),
                    end: Alignment(0.5, 1),
                    colors: [Colors.white, const Color(0xfff8f9ff)])),
            child: Row(
              children: [
                SizedBox(width: 90,),
                Container(
                  width: 1.sw - 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.circularDesc!),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.attachment!.isEmpty
                              ? 0
                              : widget.attachment!.length,
                          itemBuilder: (ctx, i) =>
                              // Text('atta$i-${widget.attachment![i]}'),
                          //attachment(widget.cicularTitle!,widget.attachment![i],i)
                          AttachmentWidget(
                            childId: widget.childId,
                            attUrl: widget.attachment![i],
                            circularTitle: widget.cicularTitle!,
                            totalAtt: i,
                          )
                        ),
                      ),
                      Text('Issued by ${widget.senderName!}')
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  // Widget attachment(String title,String url,int nos) => Container(
  //   //width: 100,
  //   height: 40,
  //   color: Colors.white,
  //   child: Row(children: [
  //     Container(
  //       width: 200,
  //       height: 32,
  //       //color: Colors.blue,
  //       decoration: BoxDecoration(
  //           color: ColorUtil.attachmentColor,
  //           borderRadius: BorderRadius.circular(10)
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(4.0),
  //         child: Row(
  //
  //           children: [
  //             Transform.rotate(
  //                 angle: 270 * math.pi/180,
  //                 child: Icon(Icons.attachment,color: ColorUtil.white,)),
  //             SizedBox(width: 4,),
  //             Text('Attachment-${nos+1}',style: TextStyle(
  //                 color: ColorUtil.white
  //             ),),
  //             SizedBox(width: 38,),
  //             _isDownloaded? Icon(Icons.remove_red_eye_outlined,color: ColorUtil.white,) : _isDownloading?
  //             CircularPercentIndicator(
  //               radius: 12,
  //               lineWidth: 4.0,
  //               percent: progressPer,
  //               //fillColor: ColorUtil.white,
  //               backgroundColor: ColorUtil.white,
  //               progressColor: ColorUtil.navyBlue,
  //               center: Text(progressStr,style: TextStyle(color: ColorUtil.white,fontSize: 6.sp),),
  //             ):  InkWell(
  //                 onTap: (){
  //                   openFile(url: '${ApiConstants.downloadUrl}$url',filename: '${widget.cicularTitle}_${widget.childId}_${url.split('/').last}');
  //                 },
  //                 child: Icon(Icons.arrow_circle_down,color: Colors.white,))
  //           ],
  //         ),
  //       ),
  //     ),
  //     SizedBox(width: 5,),
  //     Icon(Icons.share,color: ColorUtil.shareColor,)
  //   ],),
  // );
}


