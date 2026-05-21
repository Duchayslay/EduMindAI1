import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        child: Column(
          children: [
            Expanded(
              // page view
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    onLastPage = (index == 2);
                  });
                },
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/12/Illustration-PNG.png',
                        ),
                        Text(
                          "Plan your work",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngarts.com/files/18/Illustration-PNG-HQ-Pic.png',
                        ),
                        Text(
                          "Stay focused",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngarts.com/files/18/Illustration-PNG-HQ-Picture.png',
                        ),
                        Text(
                          "Take a break",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SmoothPageIndicator(controller: _controller, count: 3),
            const SizedBox(height: 30),

            onLastPage
                ? Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.deepPurple.shade800,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isFirstTime', false);
                        if (!mounted) return;
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      label: Text(
                        'Get started',
                        style: TextStyle(fontSize: 16),
                      ),
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  )
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.deepPurple.shade800,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      label: Text('Next', style: TextStyle(fontSize: 16)),
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
