import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../Provider/user_provider.dart';

import '../Models/user_model.dart';
import '../Screens/dashboard.dart';
import '../Screens/circular_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _userdata = Users();
  List<Map<String, Object>> _pages = [];
  int _seletedPageIndex = 0;
  List<StudentDetail> _students = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userdata = ModalRoute.of(context)!.settings.arguments as Users;
    print(_userdata.data!.data![0].username);
    _pages = [
      {
        'page': DashboardScreen(
          parentId: _userdata.data!.data![0].id.toString(),
          studentsList: _userdata.data!.data![0].studentDetails!,
        ),
        'title': 'dashboard',
        'centre': false,
      },
      {
        'page': CircularScreen(
          parentId: _userdata.data!.data![0].id.toString(),
          childId: _userdata.data!.data![0].studentDetails!.first.userId,
          acadYear: _userdata.data!.data![0].studentDetails!.first.academicYear,
        ),
        'title': 'Circular',
        'centre': true,
      }
    ];
    _students = _userdata.data!.data![0].studentDetails!;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //var data = userdata.data;
    // print(data.runtimeType);
    //var singleUser = UserDetails.fromJson(data as );
    return Scaffold(
      bottomNavigationBar: _customBottomNavBar(),
      body: Column(
        children: [
          customAppBar(
              img: 'assets/images/menu.png',
              name: _userdata.data!.data![0].parentName,
              title: _pages[_seletedPageIndex]['title'].toString(),
              isCentre: _pages[_seletedPageIndex]['centre'] as bool),
          _pages[_seletedPageIndex]['page'] as Widget
        ],
      ),
    );
  }

  Widget customAppBar(
          {String? img, String? title, bool isCentre = false, String? name}) =>
      Container(
        width: 1.sw,
        height: isCentre ? 90 : 120,
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
        child: Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: Row(
            children: [
              Container(
                //color: Colors.blue,
                padding: const EdgeInsets.only(top: 8, left: 8, right: 6),
                child: Image(
                  image: AssetImage(img!),
                  width: 40,
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
                  isCentre?  InkWell(
                      onTap: (){
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
                                    'https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=988&q=80',
                                placeholder: (context, url) => SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/userImage.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ) : Container()
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
          title: Text(
            'Select child',
            style: TextStyle(fontSize: 16.sp),
          ),
          content: setupAlertDialoadContainer(),
        ),
      );
  Widget setupAlertDialoadContainer() {
    return Container(
      height: 200, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _students.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              onTap: (){
                switch(_seletedPageIndex){
                  case 0:{
                    print(0);
                  }
                  break;
                  case 1:{
                   // print(1);
                    Navigator.of(context).pop();
                    print(_students[index].userId);
                    setState((){
                      _pages = [
                        {
                          'page': DashboardScreen(
                            parentId: _userdata.data!.data![0].id.toString(),
                            studentsList: _userdata.data!.data![0].studentDetails!,
                          ),
                          'title': 'dashboard',
                          'centre': false,
                        },
                        {
                          'page': CircularScreen(
                            parentId: _userdata.data!.data![0].id.toString(),
                            childId: _students[index].userId,
                            acadYear: _students[index].academicYear,
                          ),
                          'title': 'Circular',
                          'centre': true,
                        }
                      ];
                    });
                  }
                  break;
                  default:
                    print(2);
                }
              },
              leading: CircleAvatar(
                radius: 25,
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
                      child: Text('ADMN NO:${_students[index].admissionNumber}',style: admissionAndgrdStyle(),)),
                  //SizedBox(height: 5,),
                  Container(
                    width: 130,
                    height: 18,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                        color: Color(0xffececf9),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      'Grade ${_students[index].studentDetailClass}${_students[index].batch}',style: admissionAndgrdStyle(),),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  admissionAndgrdStyle() => TextStyle(
      color: Color(0xff34378b).withOpacity(0.5),
      fontWeight: FontWeight.w400,
      fontSize: 10.sp);
}
