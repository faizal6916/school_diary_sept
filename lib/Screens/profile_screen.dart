import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final String? username;
  final String? emailId;
  final String? address;
  final String? mobileNo;
  final List<StudentDetail>? studentList;
  const ProfileScreen({Key? key,this.username,this.address,this.emailId,this.studentList,this.mobileNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1.sw,
          height: 1.sh - 260,
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          //color: Colors.red,
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.all(Radius.circular(15)),
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
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  spreadRadius: 0)
            ],
          ),
          child: Column(

            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello,",
                      style: TextStyle(
                          color: Color(0xffe8a420),
                          fontWeight: FontWeight.w300,
                          //fontFamily: "Axiforma",
                          //fontStyle: FontStyle.normal,
                          fontSize: 18.sp),
                    ),
                    AutoSizeText(username!),
                    indicators(emailId!, 'assets/images/EmailLogo.png'),
                    indicators(mobileNo!, 'assets/images/ContactLogo.png'),
                    indicators(address!, 'assets/images/LocationLogo.png')
                  ],
                )
              ],)
            ],
          ),
        )
      ],
    );
  }
  Widget indicators(String title,String img) => Container(
    width: 1.sw/2 + 50,
    height: 50,
    //color: Colors.red,
    child: Row(
      children: [
        Image.asset(img,width: 25,height: 25,),
        SizedBox(width: 10,),
        AutoSizeText(title)
      ],
    ),
  );
}
