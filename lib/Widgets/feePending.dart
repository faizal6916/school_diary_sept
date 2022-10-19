import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';

class FeePending extends StatefulWidget {
  final String? feeMonth;
  final String? amountdue;
  final String? amountPaid;
  final String? balance;
  final String? duedate;
  final Map<dynamic,dynamic>? feeDetail;
  const FeePending({Key? key,this.feeMonth,this.amountdue,this.amountPaid,this.balance,this.duedate,this.feeDetail}) : super(key: key);

  @override
  State<FeePending> createState() => _FeePendingState();
}

class _FeePendingState extends State<FeePending> {
  var _isExpanded = false;
  var detailKey;
  List<String> keyList = [];
  var totaldue;
  var totalpaid;
  details(){
    widget.feeDetail!.forEach((key, value) {
      if(key== 'total' || key == 'late_fee'){
        return;
      }else{
        keyList.add(key);
      }

    });

  }
    String dueAmt(String keyy){
    if(widget.feeDetail!.containsKey(keyy)){
      print('OK');
      print(keyy);
      return widget.feeDetail![keyy]['demanded_amount'].toString();
    }else{
      return ' ';
    }
  }
  String paidAmt(String keyy){
    if(widget.feeDetail!.containsKey(keyy)){
      print('OK');
      print(keyy);
      return widget.feeDetail![keyy]['paid_amount'].toString();
    }else{
      return ' ';
    }
  }
  // String dueAmount(String keyy){
  //   if(widget.feeDetail!.containsKey(keyy)){
  //     widget.feeDetail!.forEach((key, value) {
  //       if(key == keyy){
  //        return value;
  //       }
  //     });
  //   }else{
  //     return '';
  //   }
  //   return '';
  // }
  @override
  void initState() {
    keyList.clear();
    details();

    print('length ${widget.feeDetail!.length}');
    widget.feeDetail!.forEach((key, value) {
      print('keee----->$value');
      print(value.runtimeType);
      // print(value[0]['balance_amount']);
     // keyList.addAll(key);
    });
    // print('list length------>${keyList.length}');
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      //height: 450,
      // color: Colors.red,
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0,0),
              blurRadius: 1,
              spreadRadius: 0
          ), BoxShadow(
              color: Colors.black12,
              offset: Offset(0,2),
              blurRadius: 6,
              spreadRadius: 0
          ), BoxShadow(
              color: Colors.black12,
              offset: Offset(0,10),
              blurRadius: 20,
              spreadRadius: 0
          )
        ],),

      child: Column(

        children: [
          Container(
            width: 1.sw,

            height: 180,
            decoration: BoxDecoration(
               //color: Colors.red,

                borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              children: [
                Container(
                  width: 1.sw,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)
                      )
                  ),
                  child: Center(child: Text('${widget.feeMonth}',style: TextStyle(
                      color:  Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                      //fontStyle:  FontStyle.normal,
                      fontSize: 16.sp
                  ))),
                ),
                feePendingTab('Amount Due', 'AED  ${widget.amountdue}'),
                feePendingTab('Amount Paid','AED  ${widget.amountPaid}'),
                feePendingTab('Balance',    'AED  ${widget.balance}'),
                feePendingTab('Due Date',    '${widget.duedate}'),
                Image.asset('assets/images/down_arrow.png',width: 20,height: 20,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 15),
            child: Stack(
              children: [
                Container(
                  width: 1.sw,
                  height: 45 * double.parse(keyList.length.toString()),
                ),
                Container(
                  width: 1.sw,
                 height: 45 * double.parse(keyList.length.toString()),
                    decoration: BoxDecoration(
                        color: ColorUtil.feegrlt,
                        borderRadius: BorderRadius.circular(15)
                    ),

                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: DottedBorder(
                    radius: Radius.circular(12),
                    borderType: BorderType.RRect,
                    color: Color(0xff24c272),
                    child:Text(''),
                  ),
                ),
                Container(
                  width: 1.sw,
                  //height: 150,

                  decoration: BoxDecoration(
                      color: ColorUtil.feebluelt,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: DottedBorder(
                    radius: Radius.circular(12),
                    borderType: BorderType.RRect,
                    color: ColorUtil.feeblue,
                    child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(2.8),
                          1: FlexColumnWidth(2.5),
                          2: FlexColumnWidth(2),
                        },
                      //defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                      children: [
                        TableRow(

                          decoration: BoxDecoration(
                            color: ColorUtil.feetitle.withOpacity(0.1)
                          ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('Description',),
                              ),
                              Text('Due',),
                              Text('Paid',)
                            ]
                        ),
                        ...keyList.asMap().map((ind,e) => MapEntry(ind, TableRow(
                            decoration: BoxDecoration(
                                color:(ind % 2 ==0) ? Colors.transparent:ColorUtil.feeblue.withOpacity(0.1)
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(e,
                                  style:  TextStyle(
                                    fontFamily: 'Axiforma',
                                    color: ColorUtil.feeblue,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    //fontStyle: FontStyle.normal,
                                    // letterSpacing: 0,

                                  ),),
                              ),
                              Text('AED ${dueAmt(e)}',style:  TextStyle(
                                fontFamily: 'Axiforma',
                                color: ColorUtil.feeblue,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                //fontStyle: FontStyle.normal,
                                // letterSpacing: 0,

                              ),),
                              Text('AED ${paidAmt(e)}',style:  TextStyle(
                                fontFamily: 'Axiforma',
                                color: ColorUtil.feeblue,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                //fontStyle: FontStyle.normal,
                                // letterSpacing: 0,

                              ),)
                            ]
                        ))).values.toList()
                        // TableRow(
                        //   children: [
                        //     ...keyList!.map((e) => Text(e)).toList()
                        //   ]
                        // )

                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 1.sw,
                    //height: 50,
                    //color: Colors.blue,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(1.7),
                            1: FlexColumnWidth(1.5),
                            2: FlexColumnWidth(2),
                          },
                        children: [
                          TableRow(
                              children: [
                                Text('Total',style: TextStyle(
                      fontFamily: 'Axiforma',
                        color: ColorUtil.feegreen,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        //fontStyle: FontStyle.normal,
                        //letterSpacing: 0,

                      )),
                                Text('AED ${widget.amountdue}',style: TextStyle(
                                fontFamily: 'Axiforma',
                                  color: ColorUtil.feegreen,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.normal,
                                  //letterSpacing: 0,

                                )),
                                Text('AED ${widget.amountPaid}',style: TextStyle(
                                fontFamily: 'Axiforma',
                                  color: ColorUtil.feegreen,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.normal,
                                  //letterSpacing: 0,

                                ))
                              ]
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: DottedBorder(
              borderType: BorderType.RRect,
                radius: Radius.circular(12),
                color: ColorUtil.feegreen,
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorUtil.feegrlt,
                      borderRadius: BorderRadius.circular(15)
                  ),
              width: 1.sw,
              height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Balance To Pay' ,style: TextStyle(
                    fontFamily: 'Axiforma',
                    color: ColorUtil.feegreen,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    //fontStyle: FontStyle.normal,
                    //letterSpacing: 0,

                  ),),
                          Text(':',style: TextStyle(
                          fontFamily: 'Axiforma',
                            color: ColorUtil.feegreen,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            //fontStyle: FontStyle.normal,
                            //letterSpacing: 0,

                          ),),
                      Text('AED ${widget.balance}',style: TextStyle(
                        fontFamily: 'Axiforma',
                        color: ColorUtil.feegreen,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        //fontStyle: FontStyle.normal,
                        //letterSpacing: 0,

                      ),)
                      
                    ],
                  ),
            )),
          )

        ],
      ),
    );
  }
  Widget feePendingTab(String left,String right) => Container(
    width: 1.sw,
    height: 20,
    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 2),
    //color: Colors.grey,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 1.sw/2 - 50,
          // color: Colors.green,
          child: AutoSizeText(left,textAlign: TextAlign.left,),
        ),
        Text(':'),
        Container(
          width: 1.sw/2 - 50,
          // color: Colors.green,
          child: AutoSizeText(

            right,textAlign: TextAlign.left,),
        ),

      ],
    ),
  );
}
