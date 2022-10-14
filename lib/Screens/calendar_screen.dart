import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:school_diary_sept_13/Util/color_util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Models/calendar_model.dart';
import '../Provider/user_provider.dart';
import '../Util/event.dart';

class CalendarScreen extends StatefulWidget {
  final String? schoolId;
  final String? childId;
  final String? acdYr;
  const CalendarScreen({Key? key,this.schoolId,this.childId,this.acdYr}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  // DateTime _selectedDay = DateTime.now();
  // DateTime _focusedDay = DateTime.now();
  late final ValueNotifier<List<Event?>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  var _isloading = false;
  var _calendarFeed = CalendarEvents();
  var totalDays = 0;
  var totalPresent = 0;
  var totalAbsent = 0;
  //var calEventSource;
   List<Event> addedEv = [];
  Map<DateTime, List<Event>> evMap = {};
  var calEvents =  LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  calenderEvents(String schoolId, String childId, String acdYear) async {
    try {
      setState(() {
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getCalendarEvents(schoolId, childId, acdYear);
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        _calendarFeed = CalendarEvents.fromJson(resp);
        print(_calendarFeed.data!.data!.fullattendance!.total);
        _calendarFeed.data!.data!.calendar!.forEach((element) {
         addedEv.add(Event(element.eventName.toString()));
          //print(element.calendar);
          evMap.addAll({
            DateTime.utc(element.date!.year,element.date!.month,element.date!.day): [Event(element.eventName.toString())]
          });
           //calEventSource = Map.fromIterable(iterable)
        });
        setState((){

        //
        // final  calEventSource = Map.fromIterable(
        //     List.generate(_calendarFeed.data!.data!.calendar!.length, (index) => index),
        //       key: (item) => DateTime.utc(_calendarFeed.data!.data!.calendar![item].date!.year, _calendarFeed.data!.data!.calendar![item].date!.month, _calendarFeed.data!.data!.calendar![item].date!.day),
        //       value: (item) => addedEv..add(Event(_calendarFeed.data!.data!.calendar![item].eventName)));
          //print('elements in evmap=${evMap.length}');
      // evMap.forEach((key, value) {
      //   print('$key ---------- ${value.length}');
      // });
        // calEventSource.forEach((key, value) {
        //   print('$key----------->${value}');
        // });
        //   if(calEventSource != null && calEventSource.isNotEmpty)
        //     calEvents.addAll(calEventSource);
          if(evMap != null && evMap.isNotEmpty)
            calEvents.addAll(evMap);
          
        });


      //  print(_dashboardfeed.data!.data!.first.type);
      //   setState(() {
      //     _items = _dashboardfeed.data!.data!;
      //   });
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  void didChangeDependencies() {
    calenderEvents(widget.schoolId!, widget.childId!, widget.acdYr!);

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void initState() {
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    //return kEvents[day] ?? [];
  return calEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }


  @override
  Widget build(BuildContext context) {
    return _isloading? shimmerLoader() : Container(
      width: 1.sw,
      height: 1.sh - 200,
      child: ListView(
        children: [
              TableCalendar<Event?>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  // Use `CalendarStyle` to customize the UI
                  outsideDaysVisible: false,
                ),
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  print(focusedDay);
                  print(focusedDay.month.runtimeType);
                  _calendarFeed.data!.data!.monthattendance!.forEach((atten) {
                    print(atten.id);
                    print(atten.id.runtimeType);

                    if(focusedDay.month != int.parse(atten.id!))
                      return;
                      print('condition satisfied');
                      setState((){
                        print(atten.absent);
                        print(atten.present);
                        print(atten.total);
                        totalAbsent = atten.absent!;
                        totalPresent = atten.present!;
                        totalDays = atten.total!;
                      });

                  });
                },
              ),
              eventIndicator(),
              attendanceBar()
        ],
      ),
      // child: Column(
      //   children: [
      //     TableCalendar<Event?>(
      //       firstDay: kFirstDay,
      //       lastDay: kLastDay,
      //       focusedDay: _focusedDay,
      //       selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      //       rangeStartDay: _rangeStart,
      //       rangeEndDay: _rangeEnd,
      //       calendarFormat: _calendarFormat,
      //       rangeSelectionMode: _rangeSelectionMode,
      //       eventLoader: _getEventsForDay,
      //       startingDayOfWeek: StartingDayOfWeek.monday,
      //       calendarStyle: CalendarStyle(
      //         // Use `CalendarStyle` to customize the UI
      //         outsideDaysVisible: false,
      //       ),
      //       onDaySelected: _onDaySelected,
      //       onRangeSelected: _onRangeSelected,
      //       onFormatChanged: (format) {
      //         if (_calendarFormat != format) {
      //           setState(() {
      //             _calendarFormat = format;
      //           });
      //         }
      //       },
      //       onPageChanged: (focusedDay) {
      //         _focusedDay = focusedDay;
      //       },
      //     ),
      //     const SizedBox(height: 8.0),
      //     Expanded(
      //       child: ValueListenableBuilder<List<Event?>>(
      //         valueListenable: _selectedEvents,
      //         builder: (context, value, _) {
      //           return ListView.builder(
      //             itemCount: value.length,
      //             itemBuilder: (context, index) {
      //               return Container(
      //                 margin: const EdgeInsets.symmetric(
      //                   horizontal: 12.0,
      //                   vertical: 4.0,
      //                 ),
      //                 decoration: BoxDecoration(
      //                   border: Border.all(),
      //                   borderRadius: BorderRadius.circular(12.0),
      //                 ),
      //                 child: ListTile(
      //                   onTap: () => print('${value[index]}'),
      //                   title: Text('${value[index]}'),
      //                 ),
      //               );
      //             },
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
  Widget shimmerLoader() => Shimmer.fromColors(
    baseColor: ColorUtil.shimmerBaseColor,
    highlightColor: ColorUtil.shimmerHglt,
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: 1.sw,
          height: 1.sh / 2 - 100 ,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: 1.sw,
          height: 100 ,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        ),
      ],
    ),
  );
  Widget eventIndicator() => Container(
    width: 1.sw,
    height: 25,
    margin: EdgeInsets.symmetric(horizontal: 60),
    //color: Colors.red,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       eachIndicator('Events', ColorUtil.eventIndiColor),
        eachIndicator('Exams', ColorUtil.examIndiColor),
        eachIndicator('Absent', ColorUtil.absentIndiColor)
      ],
    ),
  );
  Widget eachIndicator(String indicatorName,Color indicatorColor) => Container(
    width: 70,
    child: Row(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(radius: 4,backgroundColor: indicatorColor,),
        SizedBox(width: 10,),
        Text(indicatorName,style: TextStyle(
          color: ColorUtil.indicatorBlack,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),)
      ],
    ),
  );
  Widget attendanceBar() => Container(
    width: 1.sw,
    height: 100,
    padding: EdgeInsets.symmetric(horizontal: 20),
    //color: Colors.red,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        attendanceIndicator(totalDays, 'Days Total', ColorUtil.totalDaysIndicator),
        attendanceIndicator(totalPresent, 'Days Present', ColorUtil.green),
        attendanceIndicator(totalAbsent, 'Days Absent', ColorUtil.absentIndiColor)
      ],
    ),
  );
  Widget attendanceIndicator(int nos,String attIndicator,Color indColor) => Container(
    width: 100,
    height: 80,
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: indColor,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Center(child: Text('$nos')),
        ),
        SizedBox(width: 10,),
        SizedBox(width: 50,
            child: Text(attIndicator,maxLines: 2,softWrap: true,style: TextStyle(

              color: ColorUtil.indicatorBlack,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),))
      ],
    ),
  );
}
