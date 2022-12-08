import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_diary_sept_13/Widgets/feePaid.dart';
import 'package:school_diary_sept_13/Widgets/feePending.dart';

import '../Models/fee_model.dart';
import '../Provider/user_provider.dart';
import '../Util/color_util.dart';
import '../Util/spinkit.dart';

class FeeScreen extends StatefulWidget {
  final String? parentEmail;
  final String? admnNo;
  final String? dataToken;
  const FeeScreen({
    Key? key,
    this.admnNo,
    this.dataToken,
    this.parentEmail
  }) : super(key: key);

  @override
  State<FeeScreen> createState() => _FeeScreenState();
}

class _FeeScreenState extends State<FeeScreen> {
  var selectedTab = 1;
  var _isloading = false;
  var fee = FeeDetails();
  List<dynamic> feeDe = [];
  Map<String, dynamic> feePaid = {};
  List<FeeTotalDetails>? pending = [];
  List<String> voucherList = [];
  _getFee(String admnNo, String dataToken) async {
    try {
      setState(() {
        feeDe.clear();
        feePaid.clear();
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getFeeDetail(admnNo, dataToken);
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        print('its working');
        print(resp['data']['message']);
        // fee = FeeDetails.fromJson(resp);
        // print(fee.data!.details!.first.feeStatus);
        //pending = fee.data!.details;
        feeDe = resp['data']['details'];
        feePaid = resp['data']['fee_paid_data'];
        voucherList = feePaid.keys.toList();
        //print(resp['data']['fee_paid_data'].runtimeType);
        print('length of fee paid------${feePaid.length}');
        //print('length of fee paid------${feePaid.length}');
        // print('length of pending ---------->${pending!.length}');
        setState(() {
          //_ciculars = _circularList.data!.details!;
        });
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }
  String paidAmout(String keyy){
    if(feePaid.containsKey(keyy)){
      // print('OK');
      //print(keyy);
      return feePaid[keyy]['voucher_total_amount'].toString();
    }else{
      return ' ';
    }
  }
  String transDate(String keyy){
    if(feePaid.containsKey(keyy)){
      // print('OK');
      //print(keyy);
      return feePaid[keyy]['transaction_date'].toString();
    }else{
      return ' ';
    }
  }

  List<dynamic> getDetailedFee(String keyy){
    if(feePaid.containsKey(keyy)){
      // print('OK');
      //print(keyy);
      return feePaid[keyy]['details'];
    }else{
      return [];
    }
  }
  @override
  void didUpdateWidget(covariant FeeScreen oldWidget) {
    _getFee(widget.admnNo!, widget.dataToken!);
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _getFee(widget.admnNo!, widget.dataToken!);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1.sw,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 15),
          // color: Colors.green,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            boxShadow: [BoxShadow(
                color: const Color(0xccaeaed8),
                offset: Offset(0,10),
                blurRadius: 32,
                spreadRadius: 0
            )] ,
          ),
          child: Row(
            children: [tabItem('Pending', 1), tabItem('Paid', 2)],
          ),
        ),
        Stack(
          children: [
            Container(
                width: 1.sw,
                height: 1.sh - 230,
                padding: EdgeInsets.only(bottom: (selectedTab == 1)? 70:0),
                color: ColorUtil.mainBg,
                child: _isloading
                    ? ListView.builder(
                    itemCount: (1.sh - 200/5).round(), itemBuilder: (ctx, _) => skeleton)
                    : selectedTab == 1
                    ? (feeDe.isNotEmpty
                    ? MediaQuery.removePadding(
                    context: context,
                      removeTop: true,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                  itemCount: feeDe.length,
                  itemBuilder: (ctx, i) => FeePending(
                      amountdue: feeDe[i]['total_demanded'],
                      feeMonth: feeDe[i]['fee_month'],
                      amountPaid: feeDe[i]['total_paid'],
                      balance: feeDe[i]['balance'],
                      duedate: feeDe[i]['fee_last_date'],
                      feeDetail: feeDe[i]['details'],
                  ),
                ),
                    )
                    : Center(child: Text('No Pending Fee')))
                    : voucherList.isNotEmpty
                    ? MediaQuery.removePadding(
                    context: context,
                      removeTop: true,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                      itemCount: voucherList.length,
                      itemBuilder: (ctx, i) => FeePaid(
                        admsnNo: widget.admnNo,
                        parentEmail: widget.parentEmail,
                        detailList: getDetailedFee(voucherList[i]),
                        transactionDate: transDate(voucherList[i]),
                        voucherNo: voucherList[i],
                        totalAmount: paidAmout(voucherList[i],
                        ),
                      )),
                    )
                    : Text('No Fee Details Found')),
            if(selectedTab == 1)
              Positioned(
              bottom: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: ColorUtil.feegreen,
                      minimumSize: Size(1.sw - 30, 50)
                    ),
                      onPressed: (){}, child: Text('MAKE PAYMENT')),
                )),

          ],
        )
      ],
    );
  }

  Widget tabItem(String tabName, int activeIndex) => InkWell(
        onTap: () {
          setState(() {
            selectedTab = activeIndex;
            //selectedWid(selectedTab);
          });
        },
        child: Container(
          width: 1.sw / 3 - 10,
          height: 50,
          //color: Colors.blue,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 25,
                child: Text(
                  tabName,
                  style: TextStyle(
                      color: selectedTab == activeIndex
                          ? ColorUtil.tabIndicator
                          : ColorUtil.tabIndicator.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      //fontFamily: "Axiforma",
                      //fontStyle:  FontStyle.normal,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              selectedTab == activeIndex
                  ? Container(
                      width: 1.sw / 3,
                      height: 5,
                      decoration: BoxDecoration(
                          color: ColorUtil.tabIndicator,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                    )
                  : Container()
            ],
          ),
        ),
      );

  // Widget exp(Map<dynamic,dynamic> amap) {
  //   amap.map((key, value){
  //     return TableRow
  //   } );
  // }
}
