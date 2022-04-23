import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

import 'package:protalyze/config/Themes.dart';

class ProtalyzeAppContainer extends StatelessWidget {
  final Widget homePage;

  ProtalyzeAppContainer(
    this.homePage,
  ) : super();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: FlutterWebFrame(
          builder: (context) {
            return MaterialApp(
              title: 'Protalyze',
              home: homePage,
              theme: Themes.normal,
              debugShowCheckedModeBanner: false,
            );
          },
          maximumSize: Size(475.0, 812.0),
          enabled: kIsWeb,
          backgroundColor: Color.fromARGB(255, 235, 235, 235),
        ));
  }
}
