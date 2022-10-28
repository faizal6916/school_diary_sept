import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';

class ExamWidget extends StatelessWidget {
  const ExamWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw ,
      //height: 300,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

      //color: Colors.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 120,
            margin: EdgeInsets.symmetric(horizontal: 10),
           // color: Colors.green,
            decoration: BoxDecoration(
              color: ColorUtil.blue,
              borderRadius: BorderRadius.circular(20)
            ),
          ),
          Column(children: [
            Container(
              width: 1.sw - 130,
              height: 120,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)
                    ),
                    boxShadow: [BoxShadow(
                        color: const Color(0x24161616),
                        offset: Offset(0,7),
                        blurRadius: 24,
                        spreadRadius: 0
                    )] ,
                    color: Colors.white
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Biology',
                  style:  TextStyle(
                  color:  const Color(0xfff59770),
              fontWeight: FontWeight.w600,
              fontFamily: "OpenSans",
              fontStyle:  FontStyle.normal,
              fontSize: 15.sp
          )),
                      Row(
                        children: [


                          Container(
                            width: 65,
                            height: 20,

                          decoration: BoxDecoration(
                              color: ColorUtil.subBlue,
                              borderRadius: BorderRadius.circular(20)
                          ),

                            child: Center(child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.remove_red_eye_outlined,size: 14,color: ColorUtil.white,),
                                Text('View',style:  TextStyle(
                                    color:  Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "OpenSans",
                                    fontStyle:  FontStyle.normal,
                                    fontSize: 13.sp
                                ),),
                              ],
                            )),
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),


                    ],
                  ),
                  Divider(),
                  Text('chapter',style:  TextStyle(
                      color:  const Color(0xff4b4b4b),
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans",
                      fontStyle:  FontStyle.normal,
                      fontSize: 15.sp
                  ),),
                  Container(
                    width: 1.sw,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Container(
                          width: 100,
                          height: 30,
                         // color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                //color: Colors.green,
                                decoration: BoxDecoration(
                                color: ColorUtil.green,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Center(child: Text('25')),
                              ),
                              Text('/',style: TextStyle(fontSize: 22),),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: ColorUtil.greybg,
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Center(child: Text('25')),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),


                ],
              ),
            ),

          ],)

         ],
      ),
    );
  }
}
