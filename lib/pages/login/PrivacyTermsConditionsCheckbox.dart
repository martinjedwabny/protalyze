import 'package:flutter/material.dart';
import 'package:protalyze/pages/login/PrivacyTermsConditionsText.dart';

class PrivacyTermsConditionsCheckbox extends StatefulWidget {
  const PrivacyTermsConditionsCheckbox(this.callback);

  final Function(bool) callback;

  @override
  State<PrivacyTermsConditionsCheckbox> createState() => _PrivacyTermsConditionsCheckboxState();
}

class _PrivacyTermsConditionsCheckboxState extends State<PrivacyTermsConditionsCheckbox> {

  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: PrivacyTermsConditionsText('I agree with the '),
      value: agreed,
      onChanged: (newValue) {
        setState(() {
          agreed = newValue;
          this.widget.callback(newValue);
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}