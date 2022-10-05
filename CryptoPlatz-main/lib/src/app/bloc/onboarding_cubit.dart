import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCubit extends Cubit<bool> {
  OnboardingCubit() : super(true);

  Future<void> init() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    await Future.delayed(const Duration(seconds: 1));

    bool? onboarding = storage.getBool('onboarding_finished');

    emit(onboarding ?? false);
  }

  Future<void> finishOnboarding() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    storage.setBool('onboarding_finished', true);
  }
}
