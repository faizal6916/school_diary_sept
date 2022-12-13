import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_diary_sept_13/Screens/about_screen.dart';
import 'package:school_diary_sept_13/Screens/assignment_screen.dart';
import 'package:school_diary_sept_13/Screens/calendar_screen.dart';
import 'package:school_diary_sept_13/Screens/downloads.dart';
import 'package:school_diary_sept_13/Screens/fee_screen.dart';
import 'package:school_diary_sept_13/Screens/notif_screen.dart';
import 'package:school_diary_sept_13/Screens/profile_screen.dart';
import 'package:school_diary_sept_13/Screens/report_screen.dart';
import 'package:school_diary_sept_13/Screens/reset_password.dart';
import 'package:school_diary_sept_13/Screens/ticket_screen.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get_ip_address/get_ip_address.dart';
import '../Provider/user_provider.dart';

import '../Models/user_model.dart';
import '../Screens/dashboard.dart';
import '../Screens/circular_screen.dart';
import '../Util/api_constants.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  var _userdata = Users();
  List<Map<String, Object>> _pages = [];
  int _seletedPageIndex = 0;
  List<StudentDetail> _students = [];
  var _activeindex = 0;
  // var userId;
  var _selectedChild;
  String? circularId;
  var childIndex;
  bool isClicked = false;
  var photoUrl = '';
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    print('did update widget called');
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    isClicked = false;
    print('did change dependencies called');
    _userdata = ModalRoute.of(context)!.settings.arguments as Users;
    print(_userdata.data!.data![0].username);
    _selectedChild = _userdata.data!.data![0].studentDetails!.first.userId!;
    photoUrl = _userdata.data!.data![0].studentDetails!.first.photo!;
    print('photo url -----------$photoUrl');
    _getDeviceIp();
    _pages = [
      {
        'page': DashboardScreen(
          dashSwitching: switchingFrDash,
          parentId: _userdata.data!.data![0].id.toString(),
          //studentsList: _userdata.data!.data![0].studentDetails!,
          childId: _userdata.data!.data![0].studentDetails!.first.userId!,
        ),
        'title': 'dashboard',
        'centre': false,
        'isPopup': false
      },
      {
        'page': CircularScreen(
          // isClicked: false,
          //  circularId: null,
          parentId: _userdata.data!.data![0].id.toString(),
          childId: _userdata.data!.data![0].studentDetails!.first.userId,
          acadYear: _userdata.data!.data![0].studentDetails!.first.academicYear,
        ),
        'title': 'Circular',
        'centre': true,
        'isPopup': true
      },
      {
        'page': AssignmentScreen(
          parentId: _userdata.data!.data![0].id.toString(),
          childId: _userdata.data!.data![0].studentDetails!.first.userId,
          acadYear: _userdata.data!.data![0].studentDetails!.first.academicYear,
        ),
        'title': 'Assignment',
        'centre': true,
        'isPopup': true
      },
      {
        'page': CalendarScreen(
          schoolId: _userdata.data!.data![0].schoolId,
          childId: _userdata.data!.data![0].studentDetails!.first.userId,
          acdYr: _userdata.data!.data![0].studentDetails!.first.academicYear,
        ),
        'title': 'Calendar',
        'centre': true,
        'isPopup': true
      },
      {
        'page': FeeScreen(
          admnNo:
              _userdata.data!.data![0].studentDetails!.first.admissionNumber,
          dataToken: _userdata.data!.data![0].token,
          parentEmail: _userdata.data!.data![0].username,
        ),
        'title': 'Fee Details',
        'centre': true,
        'isPopup': true
      },
      {
        'page': ReportMainScreen(
          usrId: _userdata.data!.data![0].id,
          schoolId: _userdata.data!.data![0].schoolId,
          studId: _userdata.data!.data![0].studentDetails!.first.userId,
          acadYear: _userdata.data!.data![0].studentDetails!.first.academicYear,
          batchId: _userdata.data!.data![0].studentDetails!.first.batchId,
          classId: _userdata.data!.data![0].studentDetails!.first.classId,
          curriculumId:
              _userdata.data!.data![0].studentDetails!.first.curriculumId,
          sessionId: _userdata.data!.data![0].studentDetails!.first.sessionId,
        ),
        'title': 'Assessments',
        'centre': true,
        'isPopup': true
      },
      {
        'page': AboutScreen(),
        'title': 'About Us',
        'centre': true,
        'isPopup': false
      },
      {
        'page': DownloadScreen(),
        'title': 'Downloads',
        'centre': true,
        'isPopup': false
      },
      {
        'page': ProfileScreen(
          address: _userdata.data!.data![0].address,
          emailId: _userdata.data!.data![0].username,
          mobileNo: _userdata.data!.data![0].mobile,
          username: _userdata.data!.data![0].name,
          studentList: _userdata.data!.data![0].studentDetails,
        ),
        'title': 'Profile',
        'centre': true,
        'isPopup': false
      },
      {
        'page': TicketScreen(),
        'title': 'Ticket',
        'centre': true,
        'isPopup': false
      },
      {
        'page': ResetPassword(email: _userdata.data!.data![0].username),
        'title': 'Reset Password',
        'centre': true,
        'isPopup': false
      }
    ];
    _students = _userdata.data!.data![0].studentDetails!;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  _pageSwitching(int pageIndex) {

    setState(() {
      _activeindex = pageIndex;
      _selectedChild = _students[pageIndex].userId!;
      photoUrl = _students[pageIndex].photo!;
      print('photo url in popup----$photoUrl');
      _pages = [
        {
          'page': DashboardScreen(
            dashSwitching: switchingFrDash,
            parentId: _userdata.data!.data![0].id.toString(),
            // studentsList: _userdata.data!.data![0].studentDetails!,
            childId: _students[pageIndex].userId!,
          ),
          'title': 'dashboard',
          'centre': false,
          'isPopup': false
        },
        {
          'page': CircularScreen(
            //  isClicked: isClicked,
            // circularId: circularId,
            parentId: _userdata.data!.data![0].id.toString(),
            childId: _students[pageIndex].userId,
            acadYear: _students[pageIndex].academicYear,
          ),
          'title': 'Circular',
          'centre': true,
          'isPopup': true
        },
        {
          'page': AssignmentScreen(
            parentId: _userdata.data!.data![0].id.toString(),
            childId: _students[pageIndex].userId,
            acadYear: _students[pageIndex].academicYear,
          ),
          'title': 'Assignment',
          'centre': true,
          'isPopup': true
        },
        {
          'page': CalendarScreen(
            schoolId: _userdata.data!.data![0].schoolId,
            childId: _students[pageIndex].userId,
            acdYr: _students[pageIndex].academicYear,
          ),
          'title': 'Calendar',
          'centre': true,
          'isPopup': true
        },
        {
          'page': FeeScreen(
            admnNo: _students[pageIndex].admissionNumber,
            dataToken: _userdata.data!.data![0].token,
          ),
          'title': 'Fee Details',
          'centre': true,
          'isPopup': true
        },
        {
          'page': ReportMainScreen(
            usrId: _userdata.data!.data![0].id,
            schoolId: _userdata.data!.data![0].schoolId,
            studId: _students[pageIndex].userId,
            acadYear: _students[pageIndex].academicYear,
            batchId: _students[pageIndex].batchId,
            classId: _students[pageIndex].classId,
            curriculumId: _students[pageIndex].curriculumId,
            sessionId: _students[pageIndex].sessionId,
          ),
          'title': 'Assessments',
          'centre': true,
          'isPopup': true
        },
        {
          'page': AboutScreen(),
          'title': 'About Us',
          'centre': true,
          'isPopup': false
        },
        {
          'page': DownloadScreen(),
          'title': 'Downloads',
          'centre': true,
          'isPopup': false
        },
        {
          'page': ProfileScreen(
            address: _userdata.data!.data![0].address,
            emailId: _userdata.data!.data![0].username,
            mobileNo: _userdata.data!.data![0].mobile,
            username: _userdata.data!.data![0].name,
            studentList: _userdata.data!.data![0].studentDetails,
          ),
          'title': 'Profile',
          'centre': true,
          'isPopup': false
        },
        {
          'page': TicketScreen(),
          'title': 'Ticket',
          'centre': true,
          'isPopup': false
        },
        {
          'page': ResetPassword(
            email: _userdata.data!.data![0].username,
          ),
          'title': 'Reset Password',
          'centre': true,
          'isPopup': false
        }
      ];
    });
  }

  void switchingFrDash(int pageno, String id, bool isclicked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dashId', id);
    // print(pageno);
    // print('cirid in home---$id');
    setState(() {
      circularId = id;

      isClicked = isclicked;
      _pageSwitching(_activeindex);
      _seletedPageIndex = pageno;
    });
  }

  _getDeviceIp() async {
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();
    print('Ip data ----------------$data');
    print('Ip address ----------------${data['ip']}');
    //print('Ip data ----------------${data.runtimeType}');
    var logData = <String,Object>{
      'email' :  '${_userdata.data!.data![0].username}',
      'action': 'School_Diary_Home',
      'school_name': 'NIMS',
      'role_name' : 'parent',
       'timestamp_server': DateTime.now().microsecondsSinceEpoch,
      'user_agent': Platform.isIOS ? "IOS" : "Android",
      'ip_address': data['ip'],
      'timestamp_date':DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())

    };
    print('log data map -------$logData');
    print('log data map -------${logData.runtimeType}');
    var logList = [logData];
    ConnectionSettings settings = new ConnectionSettings(
        host: "mq.bmark.in",
        authProvider: new PlainAuthenticator("admin", "rabbitMQ"));
    Client client = new Client(settings: settings);
    client.channel().then((Channel channel) =>
        channel.queue("saveLog", arguments: logData).then((value) {
          value.publish(jsonEncode(logList));
          return client.close();
        }));
  }

  @override
  Widget build(BuildContext context) {
    //var data = userdata.data;
    // print(data.runtimeType);
    //var singleUser = UserDetails.fromJson(data as );
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        // await showDialog(
        //     context: context,
        //     builder: (_) => AlertDialog(
        //   title: Text('Are you sure you want to leave'),
        //   actions: [
        //     ElevatedButton(
        //         onPressed: () {
        //           willLeave = true;
        //           SystemNavigator.pop();
        //         },
        //         child: Text('YES')),
        //     ElevatedButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         child: Text('No')),
        //   ],
        //       actionsAlignment: MainAxisAlignment.center,
        // ));
        showGeneralDialog(
          context: context,
          pageBuilder: (ctx, a1, a2) {
            return Container();
          },
          transitionBuilder: (ctx, a1, a2, child) {
            var curve = Curves.easeInOut.transform(a1.value);
            return Transform.scale(
              scale: curve,
              child: AlertDialog(
                  title: Text('Exit the appliction?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          willLeave = true;
                          SystemNavigator.pop();
                        },
                        child: Text('YES')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No')),
                  ],
                      actionsAlignment: MainAxisAlignment.center,
                ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
        return willLeave;
      },
      child: Scaffold(
        key: _key,
        backgroundColor: (_pages[_seletedPageIndex]['title'] == 'Circular' ||
                _pages[_seletedPageIndex]['title'] == 'Assignment' ||
                _pages[_seletedPageIndex]['title'] == 'Downloads')
            ? ColorUtil.mainBg
            : ColorUtil.white,
        endDrawer: NotifWidget(parentId: _userdata.data!.data![0].id),
        drawer: Drawer(
          child: Container(
            width: double.infinity,
            height: 1.sh,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  width: double.infinity,
                  height: 1.sh - 140,
                  // color: Colors.red,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0.06.sh,
                      ),
                      buildHeader(
                        urlImage:
                            '${ApiConstants.baseUrl}${_userdata.data!.data![0].image}',
                        name: _userdata.data!.data![0].name.toString(),
                        email: _userdata.data!.data![0].username.toString(),
                      ),
                      SizedBox(
                        height: 0.03.sh,
                      ),
                      Divider(
                        thickness: 2,
                        color: Color(0xfffed330),
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/homeicon.png',
                          menuTitle: 'Home',
                          menuIndex: 0),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                        indent: 0.1.sw,
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/ic_about.png',
                          menuTitle: 'About',
                          menuIndex: 6),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                        indent: 0.1.sw,
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/ic_downloads.png',
                          menuTitle: 'Downloads',
                          menuIndex: 7),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                        indent: 0.1.sw,
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/ic_profile.png',
                          menuTitle: 'My Profile',
                          menuIndex: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                        indent: 0.1.sw,
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/ic_report_card.png',
                          menuTitle: 'Report Cards',
                          menuIndex: 5),
                      // Divider(
                      //   height: 1,
                      //   thickness: 1,
                      //   color: Colors.grey.shade200,
                      //   indent: 0.1.sw,
                      // ),
                      // _drawerItem(
                      //     imgLoc: 'assets/images/ic_report_card.png',
                      //     menuTitle: 'Ticket',
                      //     menuIndex: 9),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.yellow.shade100,
                          //image: DecorationImage(image: AssetImage('assets/images/dubai.png'))
                        ),
                        child: Image(
                          image: AssetImage('assets/images/dubai.png'),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.black54,
                        indent: 0.05.sw,
                        endIndent: 0.05.sw,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Center(
                                          child: Text(
                                            'Logout',
                                            style: TextStyle(
                                              color: Color(0xfffc5c65),
                                              fontSize: 16.sp,
                                              fontFamily: 'Axiforma',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        content: Container(
                                          width: double.infinity,
                                          height: 20,
                                          child: Center(
                                            child: Text(
                                                'Are you sure want to Logout'),
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  var sta1 = await prefs
                                                      .remove('loginResp');
                                                  var sta2 = await prefs
                                                      .remove('isLogged');
                                                  //print('---$sta1----$sta2');
                                                  if (sta1 == true &&
                                                      sta2 == true) {
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                            context,
                                                            LoginScreen.routeName,
                                                            (route) => false);
                                                  }
                                                  setState(() {
                                                    //isLoading = true;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  primary: Color(0xff8e2de2),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                ),
                                                child: Text('Yes'),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    primary: Colors.grey,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('No'))
                                            ],
                                          )
                                        ],
                                      ));
                            },
                            child: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_circle_left_outlined,
                                    color: Color(0xfffc5c65),
                                    size: 30.sp,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Log Out',
                                    style: TextStyle(
                                      color: const Color(0xff787878),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Axiforma",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.sp,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                              width: 160,
                              child: _drawerItem(
                                  imgLoc: 'assets/images/Unlock@2x.png.png',
                                  menuTitle: 'Reset Password',
                                  menuIndex: 10)),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.of(context).pop();
                          //     Navigator.pushNamed(context, '/resetpassword');
                          //   },
                          //   child: SizedBox(
                          //     width: 150,
                          //     child: Row(
                          //       children: [
                          //         Icon(
                          //           Icons.lock,
                          //           color: Color(0xff25dbdc),
                          //         ),
                          //         SizedBox(
                          //           width: 5,
                          //         ),
                          //         Text('Reset password')
                          //       ],
                          //     ),
                          //   ),
                          // )
                          //_drawerItem(imgLoc: 'assets/images/Unlock@2x.png.png', menuTitle: 'Reset Password', menuIndex: 9)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: _customBottomNavBar(),
        body: Column(
          children: [
            _pages[_seletedPageIndex]['centre'] as bool
                ? customAppBar(
                    isPop: _pages[_seletedPageIndex]['isPopup'] as bool,
                    img: 'assets/images/menu.png',
                    name: _userdata.data!.data![0].parentName,
                    title: _pages[_seletedPageIndex]['title'].toString(),
                    isCentre: _pages[_seletedPageIndex]['centre'] as bool)
                : Stack(
                    children: [
                      Container(
                        width: 1.sw,
                        height: 280,
                      ),
                      customAppBar(
                          isPop: _pages[_seletedPageIndex]['isPopup'] as bool,
                          img: 'assets/images/menu.png',
                          name: _userdata.data!.data![0].parentName,
                          title: _pages[_seletedPageIndex]['title'].toString(),
                          isCentre: _pages[_seletedPageIndex]['centre'] as bool),
                      Positioned(
                        top: 100,
                        child: Container(
                          width: 1.sw,
                          height: 180,
                          child: CarouselSlider.builder(
                            itemCount: _students.length,
                            itemBuilder: (context, index, realIndex) {
                              // final name = _students[index].name;
                              // final classofstd = _students[index].studentDetailClass;
                              // final batchofstd = _students[index].batch;
                              // final imgUrl =
                              //     'https://teamsqa3000.educore.guru${_students[index].photo}';
                              final name = _students[_activeindex].name;
                              final classofstd =
                                  _students[_activeindex].studentDetailClass;
                              final batchofstd = _students[_activeindex].batch;
                              final imgUrl =
                                  'https://teamsqa3000.educore.guru${_students[_activeindex].photo}';
                              return nameCard(
                                  studentName: name.toString(),
                                  photourl: photoUrl,
                                  grade: batchofstd.toString(),
                                  classofstd: classofstd.toString());
                            },
                            options: CarouselOptions(
                              initialPage: _activeindex,
                                height: 170,
                                //enlargeCenterPage: true,
                                viewportFraction: 1,
                                //enableInfiniteScroll: true,
                                onPageChanged: (index, reason) {
                                  print('index------$index');
                                  print('rea------$reason');
                                  setState((){
                                    _activeindex = index;
                                    _pageSwitching(_activeindex);
                                  });

                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
            _pages[_seletedPageIndex]['page'] as Widget
          ],
        ),
      ),
    );
  }

  Widget nameCard(
          {required String studentName,
          required String photourl,
          required String grade,
          required String classofstd}) =>
      Container(
        width: 1.sw - 40,
        //height: 210,
        padding: EdgeInsets.symmetric(vertical: 15),
        //margin: EdgeInsets.symmetric(horizontal: 20),
        //margin: EdgeInsets.only(bottom: -2),
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.black12,
          //       offset: Offset(0, 0),
          //       blurRadius: 1,
          //       spreadRadius: 0),
          //   BoxShadow(
          //       color: Colors.black12,
          //       offset: Offset(0, 2),
          //       blurRadius: 6,
          //       spreadRadius: 0),
          //   // BoxShadow(
          //   //     color: Colors.black12,
          //   //     offset: Offset(0, 10),
          //   //     blurRadius: 20,
          //   //     spreadRadius: 0)
          // ],
          boxShadow: [
            BoxShadow(
                color: const Color(0xccaeaed8),
                offset: Offset(0, 10),
                blurRadius: 16,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xff8829e1),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  child: CachedNetworkImage(
                    imageUrl: photourl,
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
            ),
            SizedBox(
              height: 5,
            ),
            AutoSizeText(
              studentName,
              maxLines: 1,
              style: TextStyle(
                  color: Color(0xff8829e1),
                  fontFamily: 'Axiforma',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Grade',
                  style: TextStyle(
                      color: Color(0xffcd758e),
                      fontFamily: 'Axiforma',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  classofstd,
                  style: TextStyle(
                      color: Color(0xffcd758e),
                      fontFamily: 'Axiforma',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  grade,
                  style: TextStyle(
                      color: Color(0xffcd758e),
                      fontFamily: 'Axiforma',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            buildIndicator()
          ],
        ),
      );

  Widget _drawerItem(
          {required String imgLoc,
          required String menuTitle,
          required int menuIndex}) =>
      InkWell(
        onTap: () {
          setState(() {
            Navigator.of(context).pop();
            _seletedPageIndex = menuIndex;
            print(_seletedPageIndex);
          });
        },
        child: Container(
          width: double.infinity,
          height: 40,
          //padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Image(
                image: AssetImage(imgLoc),
                width: 30,
                height: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                menuTitle,
                style: TextStyle(
                  color: const Color(0xff787878),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Axiforma",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: _activeindex,
        count: _students.length,
        effect: SlideEffect(dotWidth: 9, dotHeight: 9),
      );

  Widget customAppBar(
          {String? img,
          String? title,
          bool isCentre = false,
          String? name,
          bool isPop = false}) =>
      Container(
        width: 1.sw,
        height: isCentre ? 90 : 120,
        decoration: title == 'About Us'? BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/MaskGroup3.png',
            ),
            fit: BoxFit.cover,
          ),
        ): BoxDecoration(
          //color: ColorUtil.mainBg,
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
        child: Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  _key.currentState!.openDrawer();
                },
                child: Container(
                  //color: Colors.blue,
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 6),
                  child: Image(
                    image: AssetImage(img!),
                    width: 40,
                  ),
                ),
              ),
              SizedBox(
                width: 1.sw - 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isCentre
                        ? SizedBox(
                            width: 1.sw - 140,
                            child: Center(
                              child: Text(
                                title!,
                                style: TextStyle(
                                    color: ColorUtil.white, fontSize: 24),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hello,',
                                  style: TextStyle(
                                      color: const Color(0xffe8a420),
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14.sp),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: const Color(0xfffed330),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                    (isPop)
                        ? InkWell(
                            onTap: () {
                              _selectChildPopUp(context: context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, top: 8),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 22,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                         photoUrl,
                                      placeholder: (context, url) => SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/userImage.png',
                                        width: 42,
                                        height: 42,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  Widget _customBottomNavBar() => Container(
        width: double.infinity,
        height: 90,
        padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                offset: Offset(1, 1),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            navBarItem(
                navIcon: Icons.campaign_outlined,
                navLabel: 'Circular',
                indexPassed: 1,
                selectedBg: Color(0xffffc8d1),
                selectedBgScnd: Color(0xfffff6f7),
                icnColor: Color(0xfffd3a84)),
            navBarItem(
                navIcon: Icons.menu_book_outlined,
                navLabel: 'Assignment',
                indexPassed: 2,
                selectedBg: Color(0xffaddcff),
                selectedBgScnd: Color(0xffeaf6ff),
                icnColor: Color(0xff5558ff)),
            navBarItem(
                navIcon: Icons.calendar_month_outlined,
                navLabel: 'Calendar',
                indexPassed: 3,
                selectedBg: Color(0xffffbef9),
                selectedBgScnd: Color(0xfffff1ff),
                icnColor: Color(0xffa93aff)),
            navBarItem(
                navIcon: Icons.payments_outlined,
                navLabel: 'Fee',
                indexPassed: 4,
                selectedBg: Color(0xffc3ffe8),
                selectedBgScnd: Color(0xfff0fff4),
                icnColor: Color(0xff00b59c)),
            navBarItem(
                navIcon: Icons.pie_chart,
                navLabel: 'Assessment',
                indexPassed: 5,
                selectedBg: Color(0xffffc8d1),
                selectedBgScnd: Color(0xfffff6f7),
                icnColor: Color(0xfffd3a84))
          ],
        ),
      );
  Widget navBarItem(
          {required IconData navIcon,
          required String navLabel,
          required int indexPassed,
          required Color selectedBg,
          required Color selectedBgScnd,
          required Color icnColor}) =>
      InkWell(
        onTap: () {
          setState(() {
            _seletedPageIndex = indexPassed;
          });
        },
        child: Container(
          width: 70,
          height: 70,

          // decoration: BoxDecoration(
          //   color: Colors.grey,
          //   borderRadius: BorderRadius.circular(30)
          //
          // ),
          child: Column(
            children: [
              Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      //color: Colors.grey,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: _seletedPageIndex == indexPassed
                              ? [selectedBg, selectedBgScnd]
                              : [Color(0xfff2f2f2), Color(0xfff2f2f2)]),
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    navIcon,
                    color: _seletedPageIndex == indexPassed
                        ? icnColor
                        : Color(0xff818181),
                  )),
              Text(
                navLabel,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'Axiforma',
                  fontWeight: FontWeight.w400,
                  color: _seletedPageIndex == indexPassed
                      ? icnColor
                      : Color(0xff787878),
                ),
              )
            ],
          ),
        ),
      );
  _selectChildPopUp({
    required BuildContext context,
  }) =>
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Text(
              'Select child',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          content: setupAlertDialoadContainer(),
        ),
      );
  Widget setupAlertDialoadContainer() {
    return Container(
     // height: 240,
      height: (_students.length > 3) ? 240 : _students.length * 60 + 80, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _students.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                _pageSwitching(index);
                // switch(_seletedPageIndex){
                //   case 0:{
                //     print(0);
                //   }
                //   break;
                //   case 1:{
                //    // print(1);
                //     Navigator.of(context).pop();
                //     print(_students[index].userId);
                //     setState((){
                //       _pages = [
                //         {
                //           'page': DashboardScreen(
                //             parentId: _userdata.data!.data![0].id.toString(),
                //             //studentsList: _userdata.data!.data![0].studentDetails!,
                //             childId: _students[index].userId!,
                //           ),
                //           'title': 'dashboard',
                //           'centre': false,
                //         },
                //         {
                //           'page': CircularScreen(
                //             parentId: _userdata.data!.data![0].id.toString(),
                //             childId: _students[index].userId,
                //             acadYear: _students[index].academicYear,
                //           ),
                //           'title': 'Circular',
                //           'centre': true,
                //         }
                //       ];
                //     });
                //   }
                //   break;
                //   default:
                //     print(2);
                // }
              },
              tileColor: _selectedChild == _students[index].userId
                  ? ColorUtil.lightPurple.withOpacity(0.2)
                  : ColorUtil.white,
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: ColorUtil.lightPurple,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  child: CachedNetworkImage(
                    imageUrl:  _students[index].photo!,
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
              title: Text(
                _students[index].name!,
                style: TextStyle(
                  color: const Color(0xff34378b),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Axiforma",
                  fontSize: 13.sp,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 130,
                      height: 18,
                      margin: EdgeInsets.only(bottom: 4),
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                          color: Color(0xffececf9),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        'ADMN NO:${_students[index].admissionNumber}',
                        style: admissionAndgrdStyle(),
                      )),
                  //SizedBox(height: 5,),
                  Container(
                    width: 130,
                    height: 18,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                        color: Color(0xffececf9),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      'Grade ${_students[index].studentDetailClass}${_students[index].batch}',
                      style: admissionAndgrdStyle(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xff8829e1),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(60)),
                child: CachedNetworkImage(
                  imageUrl: urlImage,
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
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 180,
                child: AutoSizeText(
                  //'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
                  //maxLines: 2,
                  name,
                  maxFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(0xff517bfa),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Axiforma',
                      fontSize: 15.sp),
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  color: Color(0xffe8a420),
                  fontSize: 12.sp,
                  fontFamily: 'Axiforma',
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  admissionAndgrdStyle() => TextStyle(
      color: Color(0xff34378b).withOpacity(0.5),
      fontWeight: FontWeight.w400,
      fontSize: 10.sp);
}
