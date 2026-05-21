import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smart_learning_application/provider/timer_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<PomodoroTimer>(
          builder: (context, timer, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timer.phase,
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              SizedBox(height: 20),
              CircularPercentIndicator(
                circularStrokeCap: CircularStrokeCap.round,
                radius: 150,
                lineWidth: 30,
                arcBackgroundColor: const Color.fromARGB(255, 6, 212, 154),
                arcType: ArcType.FULL,
                percent: timer.progress,
                center: Text(
                  timer.formattedTime,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 6, 212, 154),
                    fontSize: 40,
                  ),
                ),
                progressColor: const Color.fromARGB(255, 234, 18, 18),
              ),
              SizedBox(height: 40),
              IconButton(
                icon: Icon(
                  timer.isRunning ? Icons.pause : Icons.play_arrow,
                  color: const Color.fromARGB(255, 6, 212, 154),
                  size: 80,
                ),
                onPressed: timer.toggleTimer,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushNamed(context, '/settings');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
        ],
      ),
    );
  }
}
