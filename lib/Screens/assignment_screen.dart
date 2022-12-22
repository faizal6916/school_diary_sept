import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:school_diary_sept_13/Models/assignment_model.dart';
import 'package:school_diary_sept_13/Util/spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Provider/user_provider.dart';
import '../Util/color_util.dart';
import '../Widgets/circular_widget.dart';

class AssignmentScreen extends StatefulWidget {
  final String? parentId;
  final String? childId;
  final String? acadYear;
  const AssignmentScreen({Key? key, this.parentId, this.childId, this.acadYear})
      : super(key: key);

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  var _assignList = Assignment();
  var _isloading = false;
  List<AssignDetails> _assignments = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() {
    // monitor network fetch
    _getAssignment(widget.parentId!, widget.childId!, widget.acadYear!);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  _getAssignment(String parentId, String childId, String acadYear) async {
    try {
      setState(() {
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getAssignment(parentId, childId, acadYear);
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        print('its working');
        _assignList = Assignment.fromJson(resp);
        _assignments = _assignList.data!.details!;
        // _circularList = Circular.fromJson(resp);
        //print(_circularList.data!.details!.first.title);
        setState(() {
          // _ciculars = _circularList.data!.details!;
        });
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  @override
  void didChangeDependencies() {
    _getAssignment(widget.parentId!, widget.childId!, widget.acadYear!);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AssignmentScreen oldWidget) {
    _getAssignment(widget.parentId!, widget.childId!, widget.acadYear!);
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorUtil.mainBg,
      height: 1.sh - 180,
      //width: 1.sw,
      padding: EdgeInsets.only(top: 10, bottom: 5),
      child: _isloading
          ? ListView.builder(itemCount: (1.sh/150).round(), itemBuilder: (ctx, _) => skeleton)
          : _assignments.isEmpty
              ? Center(child: Text('No Assignments Found'))
              : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  enablePullDown: true,
                  child: Container(
                    height: 1.sh - 180,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _assignments.length,
                        // itemBuilder: (ctx, index) => circularShowWidget(
                        //     date: _ciculars[index].dateAdded!,
                        //     title: _ciculars[index].title,sender: _ciculars[index].sendBy,desc: _ciculars[index].description,attachment: _ciculars),
                        itemBuilder: (ctx, index) => CircularWidget(
                          webLink: _assignments[index].weblink,
                            circId: _assignments[index].id,
                            typeCorA: 'Assignment',
                            childId: widget.childId,
                            cicularTitle: _assignments[index].title,
                            circularDesc: _assignments[index].description,
                            circularDate: _assignments[index].dateAdded,
                            senderName: _assignments[index].senderName,
                            attachment: _assignments[index].attachments),
                      ),
                    ),
                  ),
                ),
    );
  }
}
