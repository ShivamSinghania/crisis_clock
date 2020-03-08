// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  wordText,
  timeText,
  wordShadow,
  timeShadow,
}

final _lightColors = {
  _Element.background: [Colors.yellow[500], Colors.yellow[100]],
  _Element.wordText: Colors.red[400],
  _Element.wordShadow: Colors.red[900],
  _Element.timeText: Colors.amber[700],
  _Element.timeShadow: Colors.brown[600],
};

final _darkColors = {
  _Element.background: [Colors.grey[900], Colors.grey[800]],
  _Element.wordText: Colors.white70,
  _Element.wordShadow: Colors.grey[600],
  _Element.timeText: Colors.white,
  _Element.timeShadow: Colors.grey[600],
};

class CrisisClock extends StatefulWidget {
  CrisisClock(this.model);
  final ClockModel model;

  @override
  _CrisisClockState createState() => _CrisisClockState();
}

class _CrisisClockState extends State<CrisisClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(CrisisClock oldWidget) {
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
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool is24 = widget.model.is24HourFormat;
    final time = DateFormat(is24 ? 'HH:mm' : 'hh:mm').format(_dateTime);

    final bool isDark = Theme.of(context).brightness != Brightness.light;
    final colorTheme = isDark ? _darkColors : _lightColors;

    final timeTextStyle = TextStyle(
      height: 1.25,
      fontFamily: 'Frijole',
      color: colorTheme[_Element.timeText],
      fontSize: MediaQuery.of(context).size.width / 5,
      shadows: [
        Shadow(
          color: colorTheme[_Element.timeShadow],
          offset: Offset(9, -9),
        ),
      ],
    );

    final wordTextStyle = TextStyle(
      wordSpacing: -10,
      letterSpacing: 5,
      fontFamily: 'FreckleFace',
      color: colorTheme[_Element.wordText],
      fontSize: MediaQuery.of(context).size.width / 12,
      shadows: [
        Shadow(
          color: colorTheme[_Element.wordShadow],
          offset: Offset(4, -4),
        ),
      ],
    );

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: colorTheme[_Element.background],
          ),
        ),
        child: Column(
          children: <Widget>[
            Text('Time  to  Act  Now !', style: wordTextStyle),
            Expanded(child: Center(child: Text(time, style: timeTextStyle))),
            Text('#ClimateCrisis', style: wordTextStyle),
          ],
        ),
      ),
    );
  }
}
