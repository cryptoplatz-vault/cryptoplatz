import 'package:crypto_platz/src/app/bloc/onboarding_cubit.dart';
import 'package:crypto_platz/src/app/theme/app_fonts.dart';
import 'package:crypto_platz/src/app/view/onboarding_controller.dart';
import 'package:crypto_platz/src/features/tabs/view/tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeController extends StatelessWidget {
  const WelcomeController({super.key});

  static const String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return const _WelcomeView();
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, bool>(
      listener: (context, state) {
        if (!state) {
          Navigator.pushNamed(context, OnboardingController.routeName);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, TabsController.routeName, (route) => false);
        }
      },
      child: Scaffold(
          body: SafeArea(
              child: Center(
        child: Column(
          children: [
            const SizedBox(height: 190),
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 30),
            Text('Seed Phase Storage', style: AppFonts.welcome)
          ],
        ),
      ))),
    );
  }
}
