import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color? color;
  final double? size;

  const CustomProgressIndicator({
    Key? key, 
    this.color = const Color(0xFF1C32A4), // Default to ARMM Blue
    this.size = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFoldingCube(
        color: color!,
        size: size!,
      ),
    );
  }
}
