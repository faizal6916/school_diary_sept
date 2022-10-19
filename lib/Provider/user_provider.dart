import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../Models/user_model.dart';
import '../Util/api_constants.dart';
import '../Models/login_model.dart';


class UserProvider with ChangeNotifier {
 // var users = Users();

  // Users get userdetails{
  //   return users;
  // }

  Future<dynamic> getUserDetails(Login user) async{
    var url = '${ApiConstants.baseUrl}${ApiConstants.login}';
   try{

     print(url);
     Map<String, String> apiHeader = {
       'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
       'Content-Type': 'application/json',
       'API-Key': '525-777-777'
     };
     Map<String,String> apiBody = {
       'username': user.username,
       'password': user.password
     };

     var request = http.Request('POST',Uri.parse(url));
     request.body=(json.encode(apiBody));
     print('Login api body---------------------->${request.body}');
     request.headers.addAll(apiHeader);
     http.StreamedResponse response = await request.send();
     var respString = await response.stream.bytesToString();
    // print(json.decode(respString));
    //  if(json.decode(respString)['status']['code']==200){
    //    users = Users(
    //      status: json.decode(respString)['status'],
    //      data: json.decode(respString)['data']
    //    );
    //    notifyListeners();
    //  }
     return json.decode(respString);

   }catch(error){
     print(error);
     throw error;
   }

  }

  Future<dynamic> getDashboardfeed(String parentId, String studId) async{
    var url = '${ApiConstants.baseUrl}${ApiConstants.dashboardFeed}/$parentId/$studId';
    print(url);
    try{
      Map<String, String> apiHeader = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json',
        'API-Key': '525-777-777'
      };
      var request = http.Request('GET',Uri.parse(url));
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    }catch(e){
      print(e);
    }

  }

  Future<dynamic> getCircular(String parentId,String childId,String acadYear) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.circular}/$parentId/$childId/$acadYear/Circular';
    print(url);
    try{
      Map<String, String> apiHeader = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json',
        'API-Key': '525-777-777'
      };
      var request = http.Request('GET',Uri.parse(url));
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    }catch(e){
      print(e);
    }

  }

  Future<dynamic> getCalendarEvents(String schoolId,String childId,String acadYear) async {
   var url = '${ApiConstants.baseUrl}${ApiConstants.calendarEvents}';
   print(url);
   try{
     Map<String, String> apiHeader = {
       'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
       'Content-Type': 'application/json',
       'API-Key': '525-777-777'
     };
     Map<String,String> apiBody = {
       "school_id": schoolId,
       "child_id": childId,
       "academic_year": acadYear
     };
     var request = http.Request('POST',Uri.parse(url));
     request.body=(json.encode(apiBody));
     print('Login api body---------------------->${request.body}');
     request.headers.addAll(apiHeader);
     http.StreamedResponse response = await request.send();
     var respString = await response.stream.bytesToString();
     //print(json.decode(respString));
     return json.decode(respString);
   }catch(e){
     print(e);
   }
  }

  Future<dynamic> getPublishedReport(String schoolId,String childId,String acadYear) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.reportPublished}';
    print(url);
    try{
      Map<String, String> apiHeader = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json',
        'API-Key': '525-777-777'
      };
      Map<String,Map<String,String>> apiBody = {
        "args": {
          "user_id": childId,
          "schoolId": schoolId,
          "passedSelectedYear": acadYear
        }
      };
      var request = http.Request('POST',Uri.parse(url));
      request.body=(json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    }catch(e){
      print(e);
    }
  }

  Future<dynamic> getExams(String schoolId,String acadYear,String currId,String batchId,String stdId,String sessionId,String clsId) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.exams}';
    print(url);
    try{
      Map<String, String> apiHeader = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json',
        'API-Key': '525-777-777'
      };
      Map<String,String> apiBody = {
        "school_id": schoolId,
        "academic_year": acadYear,
        "curriculum_id": currId,
        "batch_id": batchId,
        "student_id": stdId,
        "session_id": sessionId,
        "class_id": clsId
      };
      var request = http.Request('POST',Uri.parse(url));
      request.body=(json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    }catch(e){
      print(e);
    }
  }

  Future<dynamic> getHallticket(String stdId) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.hallTicket}';
    print(url);
    try{
      Map<String, String> apiHeader = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json',
        'API-Key': '525-777-777'
      };
      Map<String,String> apiBody = {
        "child_id": stdId
      };
      var request = http.Request('POST',Uri.parse(url));
      request.body=(json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    }catch(e){
      print(e);
    }
  }

}