// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/persistance/Authentication.dart';
import 'package:protalyze/pages/RootPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupStatusAndNavBarColors();
  runApp(MyApp());
}

void setupStatusAndNavBarColors(){
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(Themes.systemUiOverlayStyleLight);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setupFirestore();
    setupVerticalHorientation();
    return MaterialApp(
      title: 'protalyze',
      home: RootPage(auth: new Auth(),),
      theme: Themes.normal,
      debugShowCheckedModeBanner: false,
    );
  }

  void setupFirestore() async {
    try {
      await FirebaseFirestore.instance.enablePersistence();
    } catch(e) {
      print('Non critical error trying to setup Firestore persistance.');
    }
  }

  void setupVerticalHorientation(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}