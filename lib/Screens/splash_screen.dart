import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), ()=>Navigator.of(context).pushNamed(LoginScreen.routeName));
    super.initState();
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
