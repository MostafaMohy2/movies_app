import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => OnboardingCubit(),
    child: const _OnboardingView(),
  );
}

class _OnboardingContent {
  const _OnboardingContent(this.image, this.title, [this.description]);

  final String image;
  final String title;
  final String? description;
}

const _pages = [
  _OnboardingContent('assets/images/onboarding.png', 'Find Your Next\nFavorite Movie Here',
      'Get access to a huge library of movies to suit all tastes. You will surely like it.'),
  _OnboardingContent('assets/images/onboarding_1.png', 'Discover Movies',
      'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.'),
  _OnboardingContent('assets/images/onboarding_2.png', 'Explore All Genres',
      'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.'),
  _OnboardingContent('assets/images/onboarding_3.png', 'Create Watchlists',
      'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.'),
  _OnboardingContent('assets/images/onboarding_4.png', 'Rate, Review, and Learn',
      "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews."),
  _OnboardingContent('assets/images/onboarding_5.png', 'Start Watching Now'),
];

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _moveTo(int page) {
    _controller.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OnboardingCubit, int>(
        builder: (context, index) => PageView.builder(
          controller: _controller,
          itemCount: _pages.length,
          onPageChanged: context.read<OnboardingCubit>().setPage,
          itemBuilder: (context, pageIndex) {
            final page = _pages[pageIndex];
            final first = pageIndex == 0;
            final last = pageIndex == _pages.length - 1;
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(page.image, fit: BoxFit.cover, alignment: Alignment.topCenter),
                const DecoratedBox(
                  decoration: BoxDecoration(gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x44000000), AppColors.background],
                    stops: [0.35, 0.65, 1],
                  )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: first ? Colors.transparent : AppColors.background,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(page.title, textAlign: TextAlign.center,
                              style: TextStyle(fontSize: first ? 26 : 20, fontWeight: FontWeight.bold, color: Colors.white)),
                            if (page.description != null) ...[
                              const SizedBox(height: 16),
                              Text(page.description!, textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.35)),
                            ],
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: FilledButton(
                                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFC107), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                onPressed: () => last
                                    ? Navigator.of(context).pushReplacementNamed(Routes.login)
                                    : _moveTo(pageIndex + 1),
                                child: Text(first ? 'Explore Now' : last ? 'Finish' : 'Next'),
                              ),
                            ),
                            if (!first) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFFC107), side: const BorderSide(color: Color(0xFFFFC107)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  onPressed: () => _moveTo(pageIndex - 1),
                                  child: const Text('Back'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
