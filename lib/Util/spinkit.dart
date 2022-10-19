import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
final spinkit = SpinKitThreeBounce(
  size: 24,
  itemBuilder: (context, index) {
    final colors = [Colors.red,Colors.blue,Colors.green];
    final color = colors[index % colors.length];
    return DecoratedBox(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15)
      ),
    );
  },
);

final skeleton = Shimmer.fromColors(
  baseColor: Color(0xffcda4de),
  highlightColor: Color(0xffc3d0be),
  child: Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    width: 1.sw,
    height: 100,
    decoration: BoxDecoration(
        color: Colors.grey, borderRadius: BorderRadius.circular(10)),
  ),
);