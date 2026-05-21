import 'package:smart_learning_application/provider/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget buildSlider(
    String label,
    double value,
    ValueChanged<double> onChanged, {
    double max = 60,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            '$label: ${value.toInt()} min',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Slider(
          min: 1,
          max: max,
          value: value,
          divisions: (max - 1).toInt(),
          label: '${value.toInt()}',
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<PomodoroTimer>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Settings'), centerTitle: false),
      body: Column(
        children: [
          buildSlider("Focus time", (timer.focusTime ~/ 60).toDouble(), (val) {
            timer.setFocusTime(val.toInt() * 60);
          }),
          buildSlider("Short break", (timer.shortBreak ~/ 60).toDouble(), (
            val,
          ) {
            timer.setShortBreak(val.toInt() * 60);
          }),
          buildSlider("Long break", (timer.longBreak ~/ 60).toDouble(), (val) {
            timer.setLongBreak(val.toInt() * 60);
          }),
          buildSlider("Intervals", timer.intervals.toDouble(), (val) {
            timer.setIntervals(val.toInt());
          }, max: 6),
        ],
      ),
    );
  }
}
