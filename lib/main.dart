// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/persistance/Authentication.dart';
import 'package:Protalyze/pages/RootPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setupFirestore();
    return MaterialApp(
      title: 'Protalyze',
      home: RootPage(auth: new Auth(),),
      theme: Themes.normal,
      debugShowCheckedModeBanner: false,
    );
  }

  void setupFirestore() async {
    try {
      await Firestore.instance.settings(
        persistenceEnabled: true,
      );
    } catch(e) {
      print('Non critical error trying to setup Firestore persistance.');
    }
  }
}