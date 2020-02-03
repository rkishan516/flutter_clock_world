import 'dart:math';

import 'package:analog_clock/clock/clock_dial_painter.dart';
import 'package:flutter/material.dart';

class ClockFace extends StatelessWidget {
  final Color circleColor;
  final Color shadowColor;
  final Color midFaceCircleColor;
  final Color midFaceCircleRadiusExtendColor;

  ClockFace({
    this.circleColor = const Color(0xFFE1ECF7),
    this.shadowColor = const Color(0xFFD9E2ED),
    this.midFaceCircleColor = const Color(0xFFF4F9FD),
    this.midFaceCircleRadiusExtendColor = const Color(0xFFD3E0F0),
  });

  Container buildClockCircle(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 0.0,
          ),
          BoxShadow(
            color: circleColor,
            blurRadius: 10,
            spreadRadius: -8,
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: AspectRatio(
                aspectRatio: 0.75,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: midFaceCircleColor,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(8.0, 0),
                          blurRadius: 13,
                          spreadRadius: 1,
                          color: midFaceCircleRadiusExtendColor,
                        )
                      ]),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(
              min(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height) /
                  40,
            ),
            width: double.infinity,
            child: CustomPaint(
              painter: ClockDialPainter(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: buildClockCircle(context),
      ),
    );
  }
}
