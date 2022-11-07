import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/user_model.dart';
import '../Screens/login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _user = Users();
  @override
  void initState() {
    getDatafromPrefs();
    // TODO: implement initState
    //Timer(Duration(seconds: 3), ()=>Navigator.of(context).pushNamed(LoginScreen.routeName));
    super.initState();
  }
  getDatafromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('isLogged') == true){
      _user = Users.fromJson(json.decode(prefs.getString('loginResp')!));
      Timer(Duration(seconds: 3),()=>Navigator.of(context).pushNamed(HomeScreen.routeName,arguments: _user));
    }else{
      Timer(Duration(seconds: 3), ()=>Navigator.of(context).pushNamed(LoginScreen.routeName));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          child: Image.asset('assets/images/splash_bg.png',fit: BoxFit.cover,),
        ),
        Center(
          child: Image(image: AssetImage('assets/images/splash_logo.png'),
            width: 0.5.sw,
          ),
        ),
      ],
    );
  }
}
