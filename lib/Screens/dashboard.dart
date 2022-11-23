import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_diary_sept_13/Provider/user_provider.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import '../Models/user_model.dart';
import '../Models/dashboard_model.dart';

class DashboardScreen extends StatefulWidget {
  final Function dashSwitching;
  final String parentId;
  final String childId;
  //final List<StudentDetail> studentsList;
  const DashboardScreen(
      {Key? key, required this.parentId, required this.childId,required this.dashSwitching})
      : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin{
  var _activeindex = 0;
  var _isloading = false;
  var _dashboardfeed = Dashboard();
  List<DashboardItem> _items = [];
  DateFormat _circFormatter = DateFormat('dd MMMM yyyy, hh:mm a');
  DateFormat _examformatter = DateFormat('dd MMMM yyyy');
  Animation<Offset>? _slideTransition;
  AnimationController? _controller;

  _cacheAdding() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist(widget.childId);
    if(!isCacheExist){
      _dashBoardFeed(widget.parentId, widget.childId);
    }else{
      print('cache already exist');
      var CacheData = await APICacheManager().getCacheData(widget.childId);
      var caheAPi = json.decode(CacheData.syncData);
      _dashboardfeed = Dashboard.fromJson(caheAPi);
      print(_dashboardfeed.data!.data!.first.type);
      setState(() {
        _items = _dashboardfeed.data!.data!;
      });
      _controller!.forward();
    }
  }

  _dashBoardFeed(String parentId, String studId) async {
    try {
      setState(() {
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getDashboardfeed(parentId, studId);
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        APICacheDBModel cacheDBModel = APICacheDBModel(key: widget.childId, syncData: json.encode(resp));
        await APICacheManager().addCacheData(cacheDBModel);
        _dashboardfeed = Dashboard.fromJson(resp);
        print(_dashboardfeed.data!.data!.first.type);
        setState(() {
          _items = _dashboardfeed.data!.data!;
        });
        _controller!.forward();
      }
    } catch (e) {
      print(e);
    }
  }
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print('state = $state');
  // }
 @override
  void initState() {
   //WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    _slideTransition = _controller!.drive(Tween(begin: Offset(1.5, 0),end: Offset(0, 0)));
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    print('dashboard didchangede');
    _cacheAdding();
    // TODO: implement didChangeDependencies
    //_dashBoardFeed(widget.parentId, widget.childId);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    print('dashboard didupdate');
    _cacheAdding();
   // _dashBoardFeed(widget.parentId, widget.childId);
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // CarouselSlider.builder(
        //   itemCount: widget.studentsList.length,
        //   itemBuilder: (context, index, realIndex) {
        //     final name = widget.studentsList[index].name;
        //     final classofstd = widget.studentsList[index].studentDetailClass;
        //     final batchofstd = widget.studentsList[index].batch;
        //     final imgUrl =
        //         'https://teamsqa3000.educore.guru${widget.studentsList[index].photo}';
        //     return nameCard(
        //         studentName: name.toString(),
        //         photourl: imgUrl,
        //         grade: batchofstd.toString(),
        //         classofstd: classofstd.toString());
        //   },
        //   options: CarouselOptions(
        //       height: 170,
        //       //enlargeCenterPage: true,
        //       viewportFraction: 1,
        //       enableInfiniteScroll: false,
        //       onPageChanged: (index, reason) async {
        //         setState(() {
        //           _activeindex = index;
        //           print(widget.parentId);
        //           print(widget.studentsList[index].userId);
        //         });
        //         _dashBoardFeed(widget.parentId,
        //             widget.studentsList[index].userId.toString());
        //       }),
        // ),
        // _isloading
        //     ? shimmerLoader()
        //     : Container(
        //         child: Text(_dashboardfeed.data!.data!.first.type.toString()),
        //       )
        // Container(
        //   height: 1.sh /2 + 80,
        //   child: ListView(
        //     children: [
        //       circular(),
        //       exam(),
        //       report(),
        //       assignment()
        //     ],
        //   ),
        // )
        _isloading
            ? shimmerLoader()
            : _items.isEmpty
                ? Center(child: Text('No dashboard feed'))
                : RefreshIndicator(
                  onRefresh: ()=> _dashBoardFeed(widget.parentId, widget.childId),
                  child: Container(
                      height: 1.sh - 400 ,
                      child: ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (ctx, index) {
                            if (_items[index].type == 'Exam') {
                              return exam(
                                title: _items[index].academic,
                                status: _items[index].status,
                                desc: _items[index].title,
                                date: _items[index].examDate,
                              );
                            }
                            if (_items[index].type == 'Circular') {
                              return circular(
                                id: _items[index].circularId,
                                  title: _items[index].description,
                                  desc: _items[index].title,
                                  date: _items[index].feedDate);
                            }
                            if (_items[index].type == 'Report_card') {
                              return report(
                                  title: _items[index].title,
                                  date: _items[index].feedDate);
                            }
                            if (_items[index].type == 'Assignment') {
                              return assignment(
                                 id: _items[index].assignId,
                                  title: _items[index].title,
                                  date: _items[index].feedDate);
                            }
                            if (_items[index].type == 'Attendance') {
                              return Container(
                                width: 1.sw,
                                height: 80,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                padding: EdgeInsets.symmetric(horizontal: 5),

                                //color: Colors.red,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xccaeaed8),
                                        offset: Offset(0, 10),
                                        blurRadius: 32,
                                        spreadRadius: 0)
                                  ],
                                  color: const Color(0xfff5f5f5),
                                ),

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          //  color: Colors.red,
                                          decoration: BoxDecoration(
                                              // color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: CircleAvatar(
                                            radius: 28,
                                            backgroundColor: Color(0xff8829e1),
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.white,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(60)),
                                                child: CachedNetworkImage(
                                                  imageUrl: 'www.google.com',
                                                  placeholder: (context, url) =>
                                                      SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'assets/images/userImage.png',
                                                    width: 45,
                                                    height: 45,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 5,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(60)),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        //for(int i=0;i<_items[index].title!.split(' ').length - 5;i++)
                                        AutoSizeText(
                                          '${_items[index].title!.split(' ').first} is ',
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Row(
                                          children: [
                                            AutoSizeText(
                                              _items[index].title!.split(' ')[
                                                  _items[index]
                                                          .title!
                                                          .split(' ')
                                                          .length -
                                                      2],
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: (_items[index]
                                                              .title!
                                                              .split(
                                                                  ' ')[_items[
                                                                          index]
                                                                      .title!
                                                                      .split(
                                                                          ' ')
                                                                      .length -
                                                                  2]
                                                              .toUpperCase() ==
                                                          'ABSENT')
                                                      ? Colors.red
                                                      : ColorUtil.green),
                                            ),
                                            Text(
                                              ' Today',
                                              style: TextStyle(fontSize: 14),
                                            )
                                          ],
                                        )
                                        // SizedBox(
                                        //     width: 1.sw-120,
                                        //     height: 40,
                                        //     child: AutoSizeText(_items[index].title!.split(' ')[_items[index].title!.split(' ').length - 2],maxLines:2,style: TextStyle(fontSize: 14),)),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                    ),
                )
      ],
    );
  }

  // Widget nameCard(
  //         {required String studentName,
  //         required String photourl,
  //         required String grade,
  //         required String classofstd}) =>
  //     Container(
  //       width: 1.sw - 40,
  //       height: 200,
  //       padding: EdgeInsets.symmetric(vertical: 15),
  //       //margin: EdgeInsets.symmetric(horizontal: 20),
  //       margin: EdgeInsets.only(bottom: 5),
  //       decoration: BoxDecoration(
  //         boxShadow: [
  //           BoxShadow(
  //               color: Colors.black12,
  //               offset: Offset(0, 0),
  //               blurRadius: 1,
  //               spreadRadius: 0),
  //           BoxShadow(
  //               color: Colors.black12,
  //               offset: Offset(0, 2),
  //               blurRadius: 6,
  //               spreadRadius: 0),
  //           // BoxShadow(
  //           //     color: Colors.black12,
  //           //     offset: Offset(0, 10),
  //           //     blurRadius: 20,
  //           //     spreadRadius: 0)
  //         ],
  //         borderRadius: BorderRadius.circular(20),
  //         color: Colors.white,
  //       ),
  //       child: Column(
  //         children: [
  //           CircleAvatar(
  //             radius: 28,
  //             backgroundColor: Color(0xff8829e1),
  //             child: CircleAvatar(
  //               radius: 25,
  //               backgroundColor: Colors.white,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(60)),
  //                 child: CachedNetworkImage(
  //                   imageUrl: photourl,
  //                   placeholder: (context, url) => SizedBox(
  //                     width: 20,
  //                     height: 20,
  //                     child: CircularProgressIndicator(),
  //                   ),
  //                   errorWidget: (context, url, error) => Image.asset(
  //                     'assets/images/userImage.png',
  //                     width: 45,
  //                     height: 45,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           AutoSizeText(
  //             studentName,
  //             maxLines: 1,
  //             style: TextStyle(
  //                 color: Color(0xff8829e1),
  //                 fontFamily: 'Axiforma',
  //                 fontSize: 14.sp,
  //                 fontWeight: FontWeight.w500),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 'Grade',
  //                 style: TextStyle(
  //                     color: Color(0xffcd758e),
  //                     fontFamily: 'Axiforma',
  //                     fontSize: 10.sp,
  //                     fontWeight: FontWeight.w500),
  //               ),
  //               SizedBox(
  //                 width: 5,
  //               ),
  //               Text(
  //                 classofstd,
  //                 style: TextStyle(
  //                     color: Color(0xffcd758e),
  //                     fontFamily: 'Axiforma',
  //                     fontSize: 10.sp,
  //                     fontWeight: FontWeight.w500),
  //               ),
  //               Text(
  //                 grade,
  //                 style: TextStyle(
  //                     color: Color(0xffcd758e),
  //                     fontFamily: 'Axiforma',
  //                     fontSize: 10.sp,
  //                     fontWeight: FontWeight.w500),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 6,
  //           ),
  //           buildIndicator()
  //         ],
  //       ),
  //     );
  //
  // Widget buildIndicator() => AnimatedSmoothIndicator(
  //       activeIndex: _activeindex,
  //       count: widget.studentsList.length,
  //       effect: SlideEffect(dotWidth: 9, dotHeight: 9),
  //     );

  Widget shimmerLoader() => Shimmer.fromColors(
        baseColor: Color(0xffcda4de),
        highlightColor: Color(0xffc3d0be),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: 1.sw,
          height: 1.sh - 400,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        ),
      );
  //------------Circular Widget---------------------//
  Widget circular(
          {String? desc, String? photoUrl, String? title, DateTime? date, String? id}) =>
      InkWell(
        onTap: (){
          print('cirid in ontap-----$id');
          widget.dashSwitching(1,id,true);
        //  print('circular');
        },
        child: SlideTransition(
          position: _slideTransition!,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 0),
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                    spreadRadius: 0),
                // BoxShadow(
                //     color: Colors.black12,
                //     offset: Offset(0, 10),
                //     blurRadius: 20,
                //     spreadRadius: 0)
              ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: ColorUtil.circularBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ColorUtil.circularText, width: 2)),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.campaign_outlined,
                        color: ColorUtil.circularText,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Circular',
                        style: TextStyle(color: ColorUtil.circularText),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          imageUrl: photoUrl.toString(),
                          placeholder: (context, url) => SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: 1.sw - 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.toString(),
                              style: TextStyle(
                                  color: ColorUtil.circularText,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              desc.toString(),
                            ),
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'updated On',
                      style: datelabelStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: ColorUtil.dateColor.withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      _circFormatter.format(date!),
                      style: dateTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  //------------Report Widget---------------------//
  Widget report(
          {String? type, String? photoUrl, String? title, DateTime? date}) =>
      InkWell(
        onTap: (){
          widget.dashSwitching(5,'dd',true);
         // print('report');
        },
        child: SlideTransition(
          position: _slideTransition!,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 0),
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                    spreadRadius: 0),
                // BoxShadow(
                //     color: Colors.black12,
                //     offset: Offset(0, 10),
                //     blurRadius: 20,
                //     spreadRadius: 0)
              ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: ColorUtil.reportBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ColorUtil.reportText, width: 2)),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.pie_chart,
                        color: ColorUtil.reportText,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Report',
                        style: TextStyle(color: ColorUtil.reportText),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          imageUrl: photoUrl.toString(),
                          placeholder: (context, url) => SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw - 150,
                      child: Text(
                        title.toString(),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Published Date',
                      style: datelabelStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: ColorUtil.dateColor.withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      _examformatter.format(date!),
                      style: dateTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  //------------Assignment Widget---------------------//
  Widget assignment(
          {String? type, String? photoUrl, String? title, DateTime? date, String? id}) =>
      InkWell(
        onTap: (){
          widget.dashSwitching(2,id,true);
         // print('assignment');
        },
        child: SlideTransition(
          position: _slideTransition!,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 0),
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                    spreadRadius: 0),
                // BoxShadow(
                //     color: Colors.black12,
                //     offset: Offset(0, 10),
                //     blurRadius: 20,
                //     spreadRadius: 0)
              ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 130,
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: ColorUtil.assignmentBg,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: ColorUtil.assignmentText, width: 2)),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.pie_chart,
                        color: ColorUtil.assignmentText,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Assignment',
                        style: TextStyle(color: ColorUtil.assignmentText),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          imageUrl: photoUrl.toString(),
                          placeholder: (context, url) => SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw - 150,
                      child: Text(
                        title.toString(),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Published Date',
                      style: datelabelStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: ColorUtil.dateColor.withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      _circFormatter.format(date!),
                      style: dateTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  //--------------Exam Widget-----------------------//
  Widget exam(
          {String? photoUrl,
          String? title,
          String? desc,
          String? status,
          DateTime? date}) =>
      InkWell(
        onTap: () {
          widget.dashSwitching(5,'dd',true);
          //print('exam');
        },
        child: SlideTransition(
          position: _slideTransition!,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 0),
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                    spreadRadius: 0),
                // BoxShadow(
                //     color: Colors.black12,
                //     offset: Offset(0, 10),
                //     blurRadius: 20,
                //     spreadRadius: 0)
              ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 90,
                      height: 25,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          color: ColorUtil.examBg,
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: ColorUtil.examText, width: 2)),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.border_color_outlined,
                            color: ColorUtil.examText,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Exam',
                            style: TextStyle(color: ColorUtil.examText),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: 90,
                        height: 25,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: ColorUtil.examBg,
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: ColorUtil.examText, width: 2)),
                        child: Center(child: Text(status.toString()))),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          imageUrl: photoUrl.toString(),
                          placeholder: (context, url) => SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: 1.sw - 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.toString(),
                              style: TextStyle(
                                  color: ColorUtil.examText,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              desc.toString(),
                            ),
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Exam Date',
                      style: datelabelStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: ColorUtil.dateColor.withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      _examformatter.format(date!),
                      style: dateTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  var dateTextStyle =
      TextStyle(color: ColorUtil.dateColor.withOpacity(0.6), fontSize: 11);
  var datelabelStyle = TextStyle(
      color: ColorUtil.dateColor.withOpacity(0.5),
      fontSize: 11,
      fontStyle: FontStyle.italic);
}
