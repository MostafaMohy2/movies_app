import 'package:flutter_bloc/flutter_bloc.dart';

/// Tracks the current step of the onboarding presentation.
class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  static const pageCount = 6;

  void setPage(int index) {
    if (index >= 0 && index < pageCount) emit(index);
  }
}
