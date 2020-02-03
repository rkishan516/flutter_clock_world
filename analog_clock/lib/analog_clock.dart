// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:analog_clock/clock/clock_face.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'drawn_hand.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock>
    with TickerProviderStateMixin {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';

  AnimationController animationController;
  Animation animationSeconds, animationMinutes, animationHours;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _now = DateTime.now();
    // Set the initial values.
    animationController =
        AnimationController(vsync: this, duration: Duration(minutes: 60));
    animationSeconds =
        Tween(begin: 0.0, end: 120 * pi).animate(animationController);
    animationMinutes =
        Tween(begin: 0.0, end: 2 * pi).animate(animationController);
    animationHours =
        Tween(begin: 0.0, end: pi / 30).animate(animationController);
    animationController.repeat();
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      // Update once per milisecond. Make sure to do it at the beginning of each
      // new milisecond, so that the clock is accurate.
      _timer = Timer(
        Duration(milliseconds: 1) - Duration(microseconds: _now.microsecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].

    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Color(0xFF4285F4),
            // Minute hand.
            highlightColor: Color(0xFF8AB4F8),
            // Second hand.
            accentColor: Color(0xFF669DF6),
            // 0xFFD2E3FC
            backgroundColor: Color(0xFFF4F9FD),
          )
        : Theme.of(context).copyWith(

            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF1E0934),
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
          Text(_location),
        ],
      ),
    );
    bool isLightTheme =
        (Theme.of(context).brightness == Brightness.light) ? true : false;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: [
            // Clock Face
            isLightTheme
                ? ClockFace(
                  )
                : ClockFace(
                    circleColor: Color(0xFF2D164B),
                    midFaceCircleColor: customTheme.backgroundColor,
                  ),
            // Hands
            DrawnHand(
              color: isLightTheme ? Color(0xFF8392f2) :Colors.white,
              thickness: 4,
              size: 0.75,
              angleRadians:
                  _now.second * radiansPerTick + animationSeconds.value,
            ),
            DrawnHand(
              color: isLightTheme ? Color(0xFF2038d4) :Colors.white,
              thickness: 5,
              size: 0.55,
              angleRadians: _now.minute * radiansPerTick +
                  (_now.second / 60) * radiansPerTick +
                  animationMinutes.value,
            ),
            DrawnHand(
              color: isLightTheme ? Color(0xFF0A21B4) :Colors.white,
              thickness: 6,
              size: 0.475,
              angleRadians: _now.hour * radiansPerHour +
                  animationHours.value +
                  (_now.minute / 60) * radiansPerHour,
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: weatherInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
