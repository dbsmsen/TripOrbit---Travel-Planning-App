import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Plan Your Perfect Trip',
      description: 'Discover amazing destinations and plan your journey with ease',
      icon: Icons.map,
      backgroundColor: Colors.blue[50]!,
    ),
    OnboardingPage(
      title: 'Discover Tourist Spots',
      description: 'Find the best attractions and hidden gems around you',
      icon: Icons.location_on,
      backgroundColor: Colors.green[50]!,
    ),
    OnboardingPage(
      title: 'Travel Together',
      description: 'Create groups, share plans, and explore with friends',
      icon: Icons.group,
      backgroundColor: Colors.orange[50]!,
    ),
    OnboardingPage(
      title: 'Smart Recommendations',
      description: 'Get AI-powered suggestions tailored to your preferences',
      icon: Icons.lightbulb,
      backgroundColor: Colors.purple[50]!,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  type: WormType.thin,
                  spacing: 16,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.blue,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: widget.onComplete,
                  child: const Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      widget.onComplete();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(_currentPage == _pages.length - 1 ? 'Get Started' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Container(
      color: page.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.icon,
            size: 120,
            color: Colors.black87,
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _skipOnboarding() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    Navigator.pushReplacementNamed(context, '/sign-in');
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
  });
}
