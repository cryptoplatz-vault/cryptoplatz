import 'package:crypto_platz/src/app/repositories/crypto_repository.dart';
import 'package:crypto_platz/src/app/view/onboarding_controller.dart';
import 'package:crypto_platz/src/app/view/welcome_controller.dart';
import 'package:crypto_platz/src/features/tabs/view/tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/onboarding_cubit.dart';

class AppController extends StatelessWidget {
  const AppController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CryptoRepository(),
      child: BlocProvider<OnboardingCubit>(
        create: (context) => OnboardingCubit()..init(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: WelcomeController.routeName,
          routes: {
            WelcomeController.routeName: (context) => const WelcomeController(),
            OnboardingController.routeName: (context) =>
                const OnboardingController(),
            TabsController.routeName: (context) => const TabsController()
          },
        ),
      ),
    );
  }
}
