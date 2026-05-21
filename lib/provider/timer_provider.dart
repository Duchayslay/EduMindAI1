import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroTimer with ChangeNotifier {
  
  // Default settings
  int focusTime = 1500; // 25 minutes
  int shortBreak = 300; // 5 minutes
  int longBreak = 900; // 15 minutes
  int intervals = 4;

  late int _remainingTime;
  late int _totalTime;
  Timer? _timer;
  bool _isRunning = false;
  bool _isInitialized = false; // New field to track initialization

  String _phase = "Focus";
  int _completedIntervals = 0;

  PomodoroTimer() {
    _loadData();
  }

  // Getters
  String get phase => _phase;
  bool get isRunning => _isRunning;
  bool get isInitialized => _isInitialized; // Expose initialization state
  double get progress => _isInitialized ? 1 - (_remainingTime / _totalTime) : 0;
  String get formattedTime {
    if (!_isInitialized) return "00:00";
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Timer control
  void startTimer() {
    if (_isRunning || !_isInitialized) return;
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_remainingTime > 0) {
        _remainingTime--;
      } else {
        _handlePhaseSwitch();
      }
      _saveData();
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    _saveData();
    notifyListeners();
  }

  void toggleTimer() {
    if (!_isInitialized) return;
    if (_isRunning) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  // Phase logic
  void _handlePhaseSwitch() {
    stopTimer();
    if (_phase == "Focus") {
      _completedIntervals++;
      if (_completedIntervals % intervals == 0) {
        _setPhase("Long Break");
      } else {
        _setPhase("Short Break");
      }
    } else {
      _setPhase("Focus");
    }
    startTimer();
  }

  void _setPhase(String phaseName) {
    _phase = phaseName;
    switch (phaseName) {
      case "Focus":
        _remainingTime = focusTime;
        _totalTime = focusTime;
        break;
      case "Short Break":
        _remainingTime = shortBreak;
        _totalTime = shortBreak;
        break;
      case "Long Break":
        _remainingTime = longBreak;
        _totalTime = longBreak;
        break;
    }
    _saveData();
    notifyListeners();
  }

  // Settings
  void setFocusTime(int seconds) {
    focusTime = seconds;
    if (_phase == "Focus") _setPhase("Focus");
    _saveData();
    notifyListeners(); // Notify listeners about the change
  }

  void setShortBreak(int seconds) {
    shortBreak = seconds;
    if (_phase == "Short Break") _setPhase("Short Break");
    _saveData();
    notifyListeners(); // Notify listeners about the change
  }

  void setLongBreak(int seconds) {
    longBreak = seconds;
    if (_phase == "Long Break") _setPhase("Long Break");
    _saveData();
    notifyListeners(); // Notify listeners about the change
  }

  void setIntervals(int count) {
    intervals = count;
    _saveData();
    notifyListeners(); // Notify listeners about the change
  }

  // Save and Load data
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('focusTime', focusTime);
    prefs.setInt('shortBreak', shortBreak);
    prefs.setInt('longBreak', longBreak);
    prefs.setInt('intervals', intervals);
    prefs.setString('phase', _phase);
    prefs.setInt('remainingTime', _remainingTime);
    prefs.setInt('totalTime', _totalTime);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    focusTime = prefs.getInt('focusTime') ?? 1500;
    shortBreak = prefs.getInt('shortBreak') ?? 300;
    longBreak = prefs.getInt('longBreak') ?? 900;
    intervals = prefs.getInt('intervals') ?? 4;

    _phase = prefs.getString('phase') ?? "Focus";
    _totalTime = prefs.getInt('totalTime') ?? focusTime;
    _remainingTime = prefs.getInt('remainingTime') ?? _totalTime;

    _isInitialized = true; // Mark as initialized
    notifyListeners(); // Notify listeners after initialization is complete
  }
}
