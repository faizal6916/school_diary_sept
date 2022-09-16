import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Provider/user_provider.dart';

import '../Models/user_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, }) : super(key: key);
  static const routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    var userdata = ModalRoute.of(context)!.settings.arguments as Users;
    print(userdata.data!.data![0].username);
    //var data = userdata.data;
   // print(data.runtimeType);
    //var singleUser = UserDetails.fromJson(data as );
    return Scaffold(
      body: Column(
        children: [
          customAppBar(img: 'assets/images/menu.png',title: userdata.data!.data![0].parentName)
        ],
      ),
    );
  }

  Widget customAppBar({String? img,String? title}) => Container(
    width: 1.sw,
    height: 120,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      image: DecorationImage(
          image: AssetImage(
            'assets/images/MaskGroup3.png',
          ),
          fit: BoxFit.cover,

      ),

    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Row(
        children: [
          Container(
            //color: Colors.blue,
            padding: const EdgeInsets.only(top: 8, left: 8, right: 6),
            child: Image(
              image: AssetImage(img!),
              width: 40,
            ),
          ),
          SizedBox(
            width: 1.sw - 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hello,',
                        style: TextStyle(
                            color: const Color(0xffe8a420),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.sp),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: const Color(0xfffed330),
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, top: 8),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 22,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          imageUrl:
                          'https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=988&q=80',
                          placeholder: (context, url) => SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset(
                                'assets/images/userImage.png',
                                width: 20,
                                height: 20,
                              ),
                        ),
                      ),
                    ),),
                ),
              ],
            ),
          ),

        ],
      ),
    ),
  );
}
