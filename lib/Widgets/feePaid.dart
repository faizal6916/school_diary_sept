import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';

import '../Provider/user_provider.dart';

class FeePaid extends StatefulWidget {
  final String? admsnNo;
  final String? parentEmail;
  final String? voucherNo;
  final String? totalAmount;
  final String? transactionDate;
  final List<dynamic>? detailList;
  const FeePaid(
      {Key? key,
      this.voucherNo,
      this.totalAmount,
      this.transactionDate,
      this.detailList,
      this.parentEmail,
      this.admsnNo})
      : super(key: key);

  @override
  State<FeePaid> createState() => _FeePaidState();
}

class _FeePaidState extends State<FeePaid> {
  //Map<String,dynamic> detailed = {};
  //List<String> detailKeys = [];
  var _isExpanded = false;
  @override
  void initState() {
    // widget.detailList!.forEach((element) {
    //   //print(element.runtimeType);
    //   detailed.addAll(element);
    // });
    // if(detailed.isNotEmpty){
    //   detailed.forEach((key, value) {
    //     detailKeys.add(key);
    //   });
    // }
    // TODO: implement initState
    super.initState();
  }

  void _showToast(BuildContext context, String errText,Color color) {
    //final scaffold = Scaffold.of(context);
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text(errText),
      backgroundColor: color,
      margin: EdgeInsets.all(8),
      behavior: SnackBarBehavior.floating,
    ),);
    // scaffold.showSnackBar(
    //   SnackBar(
    //     content: Text(errText),
    //     backgroundColor: color,
    //     margin: EdgeInsets.all(8),
    //     behavior: SnackBarBehavior.floating,
    //   ),
    // );

  }

  _generateReceipt(String parentEmail, String admnNo, String voucher) async {
    try {
      setState(() {
        //_isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getReceipt(parentEmail, admnNo, voucher);
      print(resp);
      print('staus code-------------->${resp['message']}');
      _showToast(context,resp['message'] , Colors.red);
      if (resp['status']['code'] == 200) {
        setState(() {
          //_isloading = false;
        });

      } else if (resp['status']['code'] == 400) {
        setState(() {
          //_isloading = false;
        });
      } else {
        setState(() {
          // _isloading = false;
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      //height: isExpanded? 700 : 140,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          // BoxShadow(
          //     color: Colors.black54,
          //     offset: Offset(1, 1),
          //     //spreadRadius: 2
          //     blurRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              width: 1.sw,
              height: 140,
              //color: Colors.red,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
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
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  leftPart(date: widget.transactionDate!),
                  Positioned(
                    top: 30,
                    left: 1.sw / 4.2,
                    child: centreTile(),
                  ),
                  Positioned(
                    top: 45,
                    left: 1.sw / 4.2,
                    child: centreTile(),
                  ),
                  Positioned(
                    top: 60,
                    left: 1.sw / 4.2,
                    child: centreTile(),
                  ),
                  Positioned(
                    top: 75,
                    left: 1.sw / 4.2,
                    child: centreTile(),
                  ),
                  Positioned(
                    top: 90,
                    left: 1.sw / 4.2,
                    child: centreTile(),
                  ),
                  Positioned(
                    top: 105,
                    left: 1.sw / 4.2,
                    child: centreTile(),
                  ),
                  Positioned(
                      right: 0,
                      child: rightPart(
                          rcptNo: widget.voucherNo,
                          totalPaid: widget.totalAmount,
                          traDate: widget.transactionDate)),
                  Positioned(
                    right: 1.sw / 1.625,
                    top: -20,
                    child: ciclePart(),
                  ),
                  Positioned(right: 1.sw / 1.625, top: 120, child: ciclePart())
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              width: 1.sw,
              height:
                  45 * double.parse(widget.detailList!.length.toString()) + 60,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 0,
                      left: 0,
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          color: ColorUtil.paidBor,
                          radius: Radius.circular(12),
                          child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(5),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(2),
                            },
                            children: [
                              // ...widget.detailList!.map((e) => TableRow(
                              //   children: [
                              //     Text('${e['transaction_desc']}'),
                              //     Text(':'),
                              //     Text('${e['transaction_amount']}')
                              //   ]
                              // )).toList()
                              ...widget.detailList!
                                  .asMap()
                                  .map((index, element) => MapEntry(
                                      index,
                                      TableRow(
                                          decoration: BoxDecoration(
                                              color: (index % 2 == 0)
                                                  ? Colors.transparent
                                                  : ColorUtil.paidBor
                                                      .withOpacity(0.2)),
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                '${element['transaction_desc']}',
                                                style: feeListStyle(),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                ':',
                                                style: feeListStyle(),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'AED ${element['transaction_amount']}',
                                                style: feeListStyle(),
                                              ),
                                            )
                                          ])))
                                  .values
                                  .toList()
                            ],
                          )),
                    ),
                    Positioned(
                      top: 0,
                      left: 15,
                      child: Container(
                        width: 100,
                        color: Colors.white,
                        child: Center(child: Text('Particulars')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  color: ColorUtil.feegreen,
                  child: Container(
                    //margin: EdgeInsets.all(8),
                    width: 1.sw,
                    // height: 60,
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(5),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Grand Total',
                              style: feeTotalStyle(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              ':',
                              style: feeTotalStyle(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'AED ${widget.totalAmount!}',
                              style: feeTotalStyle(),
                            ),
                          )
                        ])
                      ],
                    ),
                  )),
            ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: Size(1.sw / 2 + 30, 40),
                    primary: ColorUtil.feegreen,
                  ),
                  onPressed: () {
                    _generateReceipt(widget.parentEmail!, widget.admsnNo!,
                        widget.voucherNo!);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Get Receipt By Email')
                    ],
                  )),
            )
        ],
      ),
    );
  }

  Widget rightPart({String? rcptNo, String? totalPaid, String? traDate}) =>
      Container(
        width: 1.sw * 2 / 3,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 230,
              height: 25,
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Color(0xff5558ff).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Receipt no.',
                    style: receiptTextStyle(),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    ':',
                    style: receiptTextStyle(),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    rcptNo!,
                    style: receiptTextStyle(),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            Container(
              width: 235,
              height: 25,
              margin: EdgeInsets.symmetric(vertical: 10),
              //padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.payments_outlined,
                    color: Color(0xff6e6e6e),
                  ),
                  Text(
                    'Total Paid',
                    style: transactionStyle(),
                  ),
                  Text(
                    ':',
                    style: transactionStyle(),
                  ),
                  Text(
                    'AED $totalPaid',
                    style: TextStyle(
                        color: Color(0xff26de81),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Axiforma",
                        fontSize: 11.sp),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down_outlined,
                    color: Color(0xff6e6e6e),
                  )
                  // Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
            Container(
              width: 230,
              height: 25,
              margin: EdgeInsets.only(bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xff6e6e6e),
                  ),
                  Text(
                    'Transaction date',
                    style: transactionStyle(),
                  ),
                  Text(
                    ':',
                    style: transactionStyle(),
                  ),
                  Text(
                    '${DateFormat('dd MMM yyyy').format(DateTime.parse('${traDate!.split('-').last}-${traDate.split('-')[1]}-${traDate.split('-').first}'))}',
                    style: transactionStyle(),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  receiptTextStyle() => TextStyle(
        fontFamily: 'Axiforma',
        color: Color(0xff5558ff),
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
      );

  transactionStyle() => TextStyle(
      color: const Color(0xff6e6e6e),
      fontWeight: FontWeight.w400,
      fontFamily: "Axiforma",
      fontSize: 11.sp);
  feeListStyle() => TextStyle(
      color: ColorUtil.paidBor,
      fontWeight: FontWeight.w400,
      fontFamily: "Axiforma",
      fontStyle: FontStyle.normal,
      fontSize: 11.sp);
  feeTotalStyle() => TextStyle(
      color: ColorUtil.feegreen,
      fontWeight: FontWeight.w700,
      fontFamily: "Axiforma",
      fontStyle: FontStyle.normal,
      fontSize: 12.sp);
  Widget ciclePart() => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20)),
      );

  Widget leftPart({required String date}) => Container(
        width: 1.sw / 3,
        height: 140,
        padding: EdgeInsets.symmetric(horizontal: 1.sw / 16, vertical: 50),
        //margin: EdgeInsets.only(right: 10),
        child: Text(
          '${DateFormat('MMM').format(DateTime.parse('${date.split('-').last}-${date.split('-')[1]}-${date.split('-').first}')).toString().toUpperCase()}',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.w700),
        ),
        decoration: BoxDecoration(
          color: Color(0xff26de81),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
      );

  Widget centreTile() => Container(
        width: 12,
        height: 5,
        color: Colors.white,
      );
}
