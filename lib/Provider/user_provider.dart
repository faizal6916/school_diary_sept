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
}