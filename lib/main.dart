// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/pages/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protalyze',
      home: HomePage(),
      theme: Themes.normal,
    );
  }
}