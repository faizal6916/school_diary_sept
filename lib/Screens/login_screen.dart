import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../Util/color_util.dart';
import '../Models/login_model.dart';
import '../Models/user_model.dart';
import '../Provider/user_provider.dart';
import '../Util/spinkit.dart';
import './home_screen.dart';
import './forget_password.dart';
import '../Util/snackBar.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _loginCred = Login(username: '', password: '');
  var _isLoading = false;
  var _user = Users();
  String? userEmail;
  bool _isObscure = true;
  bool _isNum = false;
  bool _isOtp = false;
  var otpResp;
  var otpIn;
  bool _invalid = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _passwordFocusNode.dispose();
    super.dispose();
  }

  _deleteFolder() async {
    if (await Permission.storage.request().isGranted) {
      final path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      var dir = await Directory('$path/SchoolDiary');

      if (await dir.exists()) {
        print('directory exist');
        dir.delete(recursive: true);
        //dir.deleteSync(recursive: true);
      } else {
        print('dir not exist');
      }
    }
  }

  Future<void> _saveForm() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    print(_loginCred.username);
    print(_loginCred.password);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (_isNum) {
      if (_loginCred.username.isNotEmpty) {
        setState(() {
          _isLoading = true;
         // _isOtp = true;
        });
        var dId = await _getDeviceId();
        print(dId);
        try{
          var resp = await Provider.of<UserProvider>(context, listen: false)
              .mobileLogin(_loginCred.username, dId!);
          print('mobile login resp---$resp');
          if (resp['status']['code'] == 200) {
            otpResp = resp['data']['verification_otp'];
            print(otpResp);
            setState(() {
              _isLoading = false;
               _isOtp = true;
            });
          }else{}
        }catch(e){
          print(e);
        }
      }
    } else {
      if (_loginCred.username.isNotEmpty && _loginCred.password.isNotEmpty) {
        if (connectivityResult == ConnectivityResult.none) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please check your connectivity'),
            backgroundColor: Colors.red,
          ));
        } else {
          print('not empty');
          // _deleteFolder();

          setState(() {
            _isLoading = true;
          });
          try {
            var resp = await Provider.of<UserProvider>(context, listen: false)
                .getUserDetails(_loginCred);
            print(resp.runtimeType);
            //print('staus code-------------->${resp['status']['code']}');
            if (resp['status']['code'] == 200) {
              setState(() {
                _isLoading = false;
              });
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('loginResp', json.encode(resp));
              prefs.setBool('isLogged', true);
              _user = Users.fromJson(resp);
              // _user = Users(
              //   status: resp['status'] as Map<String,dynamic>,
              //   data: resp['data']
              // );
              print(_user.status!.code);
              //print('ok');
              Navigator.of(context)
                  .pushNamed(HomeScreen.routeName, arguments: _user);
            } else if (resp['status']['code'] == 400) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(resp['error']['message']),
                backgroundColor: Colors.red,
              ));
            }
          } catch (e) {
            print(e);
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else {
        print('empty');
      }
    }
  }

  Future<void> _handleSignIn() async {
    try {
      var account = await _googleSignIn.signIn();
      print("Account: ${account!.email}");
      userEmail = account.email;
      print(userEmail);
      if (userEmail!.length == 0) {
        print('Invalid Email');
      } else {
        doGoogleSignIn(userEmail!);
      }
      // validateGoogleSignIn();
    } catch (error) {
      print(error);
    }
  }

  doGoogleSignIn(String email) async {
    try {
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .googleLogin(email);
      print(resp.runtimeType);
      //print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isLoading = false;
        });
        _user = Users.fromJson(resp);
        // _user = Users(
        //   status: resp['status'] as Map<String,dynamic>,
        //   data: resp['data']
        // );
        print(_user.status!.code);
        //print('ok');
        Navigator.of(context).pushNamed(HomeScreen.routeName, arguments: _user);
      }
    } catch (e) {
      print(e);
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
 Future<String?>  _getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  }
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: spinkit,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: 0, child: Lottie.asset('assets/animation/Login.json')),
            Positioned(
              top: 0.125.sh,
              left: 0.55.sw,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 150,
                height: 100,
              ),
            ),
            _isOtp
                ? Positioned(
                    top: 0.4.sh -
                        (MediaQuery.of(context).viewInsets.bottom / 1.5),
                    child: Container(
                        width: 1.sw,
                        height: 0.7.sh,
                        decoration: BoxDecoration(
                          color: ColorUtil.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 0.06.sh,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: (){
                                      setState(() {

                                        _isOtp = false;
                                        _isNum = false;
                                      });
                                    },
                                    child: Icon(Icons.arrow_back)),
                                SizedBox(width: 1.sw/4,),
                                Text('Verification', style: const TextStyle(
                                    color:  const Color(0xffb785e9),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Mulish",
                                    fontStyle:  FontStyle.normal,
                                    fontSize: 24.0
                                ),),
                                SizedBox(width: 1.sw/4,)
                              ],
                            ),
                            SizedBox(height: 0.06.sh,),
                            OtpTextField(
                              numberOfFields: 6,
                              borderColor: Color(0xFF512DA8),
                              //set to true to show as box or false to show as dash
                              showFieldAsBox: true,
                              keyboardType: TextInputType.number,
                              enabledBorderColor: _invalid? Colors.red : Colors.grey,
                              //disabledBorderColor: Colors.grey,
                              focusedBorderColor: Colors.purple,
                              //runs when a code is typed in
                              onCodeChanged: (String code) {
                                setState(() {
                                  _invalid = false;
                                });
                                //handle validation or checks here
                              },
                              //runs when every textfield is filled
                              onSubmit: (String verificationCode){
                                otpIn = verificationCode;

                                // showDialog(
                                //     context: context,
                                //     builder: (context){
                                //       return AlertDialog(
                                //         title: Text("Verification Code"),
                                //         content: Text('Code entered is $verificationCode'),
                                //       );
                                //     }
                                // );
                              }, // end onSubmit
                            ),
                            SizedBox(height: 0.06.sh,),
                            ElevatedButton(onPressed: () async{
                              if(otpIn == null || otpIn == ''){
                                setState(() {
                                  _invalid = true;
                                });
                                showSnackBar(context, "Please enter OTP", Colors.red);
                              }else if(otpIn == otpResp){
                                setState(() {
                                  _isLoading = true;
                                });
                                var devId = await _getDeviceId();
                                try{
                                  var resp = await Provider.of<UserProvider>(context, listen: false)
                                      .verfiOTP(_loginCred.username,devId!,otpIn);
                                  print('mob no ver-------$resp');
                                  //print('staus code-------------->${resp['status']['code']}');
                                  if (resp['status']['code'] == 200) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    _user = Users.fromJson(resp);
                                    // _user = Users(
                                    //   status: resp['status'] as Map<String,dynamic>,
                                    //   data: resp['data']
                                    // );
                                    print(_user.status!.code);
                                    //print('ok');
                                    Navigator.of(context).pushNamed(HomeScreen.routeName, arguments: _user);
                                  }

                                }catch(e){
                                  print(e);
                                }
                              }else{
                                setState(() {
                                  _invalid = true;
                                });
                                showSnackBar(context, "Invalid OTP", Colors.red);
                              }

                            }, child: Text('Verify', style: const TextStyle(
                                color:  Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: "SFProText",
                                fontStyle:  FontStyle.normal,
                                fontSize: 18.0
                            ),)  ,   style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 50),
                            primary: Color(0xff25DBDB),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(6))),),
                            SizedBox(height: 0.1.sh,),
                            Row(
                              children: [
                                SizedBox(
                                  width: 0.16.sw,
                                ),
                                Image(
                                  image: AssetImage(
                                      'assets/images/Benchmarklogo.png'),
                                  height: 35,
                                ),
                                SizedBox(
                                  width: 0.04.sw,
                                ),
                                Image(
                                  image:
                                  AssetImage('assets/images/GooglePic.png'),
                                  height: 35,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 0.04.sh,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 0.085.sh,
                                ),
                                Text(
                                  'Need any help?',
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      fontFamily: 'Axiforma',
                                      color: ColorUtil.lightPurple,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 0.01.sh,
                                ),
                                Text(
                                  'Contact:',
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      color: ColorUtil.lightPurple,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 0.004.sh,
                                ),
                                Text(
                                  'support@team-sqa.com',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: ColorUtil.lightPurple,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),),)
                : Positioned(
                    top: 0.3.sh -
                        (MediaQuery.of(context).viewInsets.bottom / 1.5),
                    child: Container(
                      width: 1.sw,
                      height: 0.7.sh,
                      decoration: BoxDecoration(
                        color: ColorUtil.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 0.03.sh,
                          ),
                          Text(
                            'Please login with registered email id',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorUtil.lightPurple,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 0.02.sh,
                          ),
                          GestureDetector(
                            onTap: _handleSignIn,
                            child: Container(
                              width: 278,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(color: Color(0xff518EF8))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 0.2.sw,
                                  ),
                                  Image(
                                      image: AssetImage(
                                          'assets/images/Googleicon.png')),
                                  SizedBox(
                                    width: 0.05.sw,
                                  ),
                                  Text(
                                    'Google',
                                    style: TextStyle(
                                        color: ColorUtil.navyBlue,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.02.sh,
                          ),
                          Text(
                            'or',
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorUtil.lightPurple),
                          ),
                          // SizedBox(
                          //   height: 0.005.sh,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, right: 25, left: 25, bottom: 15),
                            child: Form(
                              key: _form,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Email or Mobile no',
                                        icon: Icon(Icons.person_outlined),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onChanged: (value) {
                                        // var isNum = isNumeric(value);
                                        // print(isNum);
                                        setState(() {
                                          _isNum = isNumeric(value);
                                        });
                                      },
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_passwordFocusNode);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Enter Email or Mobile No';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _loginCred = Login(
                                            username: value.toString(),
                                            password: _loginCred.password);
                                      },
                                    ),
                                    SizedBox(
                                      height: 0.015.sh,
                                    ),
                                    _isNum
                                        ? SizedBox()
                                        : TextFormField(
                                            obscureText: _isObscure,
                                            decoration: InputDecoration(
                                              labelText: 'Password',
                                              icon: Icon(
                                                  Icons.lock_open_outlined),
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _isObscure = !_isObscure;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    _isObscure
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Color(0xFFD2C2FF),
                                                  )),
                                            ),
                                            textInputAction:
                                                TextInputAction.done,
                                            focusNode: _passwordFocusNode,
                                            onSaved: (value) {
                                              _loginCred = Login(
                                                  username: _loginCred.username,
                                                  password: value.toString());
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter the Password';
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (_) =>
                                                _saveForm(),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(ForgetPassword.routeName);
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 0.13.sw,
                                    ),
                                    Icon(
                                      Icons.lock_open,
                                      color: ColorUtil.lightPurple,
                                    ),
                                    SizedBox(
                                      width: 0.02.sw,
                                    ),
                                    Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Color(0xff8A8CBD),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 0.22.sw,
                              ),
                              ElevatedButton(
                                onPressed: _saveForm,
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff25DBDB),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          SizedBox(
                            height: 0.05.sh,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 0.16.sw,
                              ),
                              Image(
                                image: AssetImage(
                                    'assets/images/Benchmarklogo.png'),
                                height: 35,
                              ),
                              SizedBox(
                                width: 0.04.sw,
                              ),
                              Image(
                                image:
                                    AssetImage('assets/images/GooglePic.png'),
                                height: 35,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 0.04.sh,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 0.085.sh,
                              ),
                              Text(
                                'Need any help?',
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'Axiforma',
                                    color: ColorUtil.lightPurple,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 0.01.sh,
                              ),
                              Text(
                                'Contact:',
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    color: ColorUtil.lightPurple,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 0.004.sh,
                              ),
                              Text(
                                'support@team-sqa.com',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: ColorUtil.lightPurple,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
