import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/di.dart';
import '../../../auth/presentation/view/login_view.dart';
import '../../../auth/presentation/view_model/login/login_bloc.dart';

class OnboardingScreenView extends StatefulWidget {
  const OnboardingScreenView({super.key});

  @override
  State<OnboardingScreenView> createState() => _OnboardingScreenViewState();
}

class _OnboardingScreenViewState extends State<OnboardingScreenView> {
  int _currentPage = 0; // Tracks the current page index
  final PageController _pageController = PageController(initialPage: 0);

  void _skipToLastPage() {
    _pageController.jumpToPage(2); // Skips to the last screen
  }

  void _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: getIt<LoginBloc>(),
          child: LoginView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_currentPage != 2) // Show Skip only if not on the last page
            TextButton(
              onPressed: _skipToLastPage,
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index; // Update the current page index
          });
        },
        children: [
          _buildPage(
            image: 'assets/images/logo.png',
            title: 'Welcome to SoundSage',
            description: 'Find your perfect instrument, play and learn',
          ),
          _buildPage(
            image: 'assets/images/covdrum.jpg',
            title: 'Listen Anywhere',
            description: 'Stream music anytime, anywhere without limits.',
          ),
          _buildPage(
            image: 'assets/images/first.png',
            title: 'Get Started Now!',
            description: 'Enjoy unlimited music and playlists just for you.',
          ),
        ],
      ),
      bottomSheet: _currentPage == 2
          ? _buildGetStartedButton() // Show "Get Started" on last page
          : _buildBottomNavButtons(), // Show "Back" and "Next" buttons
    );
  }

  // Page Content Builder
  Widget _buildPage({
    required String image,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300), // Add your onboarding image here
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Buttons (Back and Next)
  Widget _buildBottomNavButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button: Hidden on the first screen
          _currentPage > 0
              ? ElevatedButton(
                  onPressed: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Back"),
                )
              : const SizedBox(), // Empty space to align Next button

          // Next Button
          ElevatedButton(
            onPressed: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[900],
              foregroundColor: Colors.white,
            ),
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  // Get Started Button on Last Page
  Widget _buildGetStartedButton() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _navigateToLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[900],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
