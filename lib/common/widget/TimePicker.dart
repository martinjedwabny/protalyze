import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class TimePicker extends Picker {
  
  TimePicker(Duration duration, Function(Duration) confirmCallback) : super(
    adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
      NumberPickerColumn(begin: 0, end: 10, suffix: Text(' h'), initValue: duration.inHours),
      NumberPickerColumn(begin: 0, end: 59, suffix: Text(' m'), initValue: duration.inMinutes % 60),
      NumberPickerColumn(begin: 0, end: 59, suffix: Text(' s'), initValue: duration.inSeconds% 60),
    ]),
    hideHeader: true,
    confirmText: 'Confirm',
    title: const Text('Select duration'),
    onConfirm: (Picker picker, List<int> value) {
      int timeInSeconds = picker.getSelectedValues()[0] * 60 * 60 + picker.getSelectedValues()[1] * 60 + picker.getSelectedValues()[2];
      confirmCallback(Duration(seconds: timeInSeconds));
    },
  );
}