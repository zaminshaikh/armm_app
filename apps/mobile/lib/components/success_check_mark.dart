import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessCheckMark extends StatelessWidget {
  final Animation<double> animation;
  
  // Using the same colors as the verify email page
  final Color backgroundColor;
  final Color outerCircleColor;
  final Color checkMarkColor;

  const SuccessCheckMark({
    Key? key,
    required this.animation,
    this.backgroundColor = const Color(0xFF32B64B),
    this.outerCircleColor = const Color(0xFF32B64B),
    this.checkMarkColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: ScaleTransition(
          scale: animation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer circle (lightest)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: outerCircleColor.withOpacity(0.2),
                ),
              ),
              // Inner circle with SVG check mark
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/check-mark.svg',
                    width: 40,
                    height: 40,
                    colorFilter: ColorFilter.mode(
                      checkMarkColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
