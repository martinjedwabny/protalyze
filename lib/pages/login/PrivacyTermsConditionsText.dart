import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:protalyze/common/widget/MarkdownMessageAlertDialog.dart';
import 'package:protalyze/pages/login/PrivacyTermsConditionsMessages.dart';

class PrivacyTermsConditionsText extends StatelessWidget {
  const PrivacyTermsConditionsText(this.leadingText);

  final String leadingText;

  static final String tosMessage = PrivacyTermsConditionsMessages.tosMessage;
  static final String ppMessage = PrivacyTermsConditionsMessages.ppMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Center(
      child: Text.rich(
        TextSpan(
          text: this.leadingText, style: TextStyle(
          fontSize: 16
        ),
          children: <TextSpan>[
            TextSpan(
              text: 'Terms of Service', style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                showDialog(context: context, builder: (context) => 
                  MarkdownMessageAlertDialog('Terms of Service',tosMessage));
                }
            ),
            TextSpan(
              text: ' and ', style: TextStyle(
              fontSize: 16
            ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Privacy Policy', style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline
                ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(context: context, builder: (context) =>  
                        MarkdownMessageAlertDialog('Privacy Policy',ppMessage));
                      }
                )
              ]
            )
          ]
        )
      )
      ),
    );
  }
}