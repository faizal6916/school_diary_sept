import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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