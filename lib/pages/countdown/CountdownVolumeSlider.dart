import 'package:flutter/material.dart';

class CountdownVolumeSlider extends StatefulWidget {
  final double initialVolume;
  final Function(double) volumeChangedCallback;
  const CountdownVolumeSlider(this.initialVolume, this.volumeChangedCallback);
  @override
  _CountdownVolumeSliderState createState() => _CountdownVolumeSliderState();
}

class _CountdownVolumeSliderState extends State<CountdownVolumeSlider> {
  @override
  Widget build(BuildContext context) {
    Widget volumeDownIcon = Icon(Icons.volume_down_outlined, size: 24, color: Colors.white70, );
    Widget volumeUpIcon = Icon(Icons.volume_up_outlined, size: 24, color: Colors.white70,);
    Widget volumeSlider = Slider(
      value: this.widget.initialVolume, 
      onChanged: (double value) {
        setState(() {
          this.widget.volumeChangedCallback(value);
        });
      },
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(padding: EdgeInsets.only(left: 20), child: volumeDownIcon),
        Expanded(child: volumeSlider),
        Padding(padding: EdgeInsets.only(right: 20), child: volumeUpIcon),
    ],);
  }
}