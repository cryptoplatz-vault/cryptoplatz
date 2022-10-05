import 'package:crypto_platz/src/app/bloc/onboarding_cubit.dart';
import 'package:crypto_platz/src/app/theme/app_colors.dart';
import 'package:crypto_platz/src/app/theme/app_fonts.dart';
import 'package:crypto_platz/src/features/tabs/view/tabs_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingController extends StatelessWidget {
  const OnboardingController({Key? key}) : super(key: key);

  static const String routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    return const _OnboardingView();
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: const [
          Tab(index: 1, text: 'Save encrypted data offline on NFC card'),
          Tab(index: 2, text: 'Transparent and open source app'),
          Tab(
              index: 3,
              text: 'Keep your seed, private key  and password safe',
              height: 65),
          Tab(
              index: 4,
              text:
                  'We do not transmit, store and neither collect any of your data')
        ],
      ),
    );
  }
}

class Tab extends StatelessWidget {
  const Tab(
      {required this.index, required this.text, this.height = 128, Key? key})
      : super(key: key);

  final int index;
  final String text;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/images/logo.png', height: 70),
            const SizedBox(height: 42),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: height < 128 ? ((128 - height) / 2) : 0),
              child: Image.asset(
                'assets/images/tab_$index.png',
                height: height,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(text,
                  style: AppFonts.welcome, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 47),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [1, 2, 3, 4]
                  .map((itemIndex) => Container(
                      height: 8,
                      width: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: itemIndex == index
                              ? AppColors.red
                              : AppColors.lightGrey)))
                  .toList(),
            ),
            const SizedBox(height: 32),
            TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  showDialog(
                    context: context,
                    useSafeArea: false,
                    builder: (context) => const _FinishOnboardingView(),
                  );
                },
                child: Text('Start',
                    style: AppFonts.custom(fontSize: 16, color: Colors.white)))
          ],
        ),
      ),
    );
  }
}

class _FinishOnboardingView extends StatefulWidget {
  const _FinishOnboardingView({Key? key}) : super(key: key);

  @override
  State<_FinishOnboardingView> createState() => _FinishOnboardingViewState();
}

class _FinishOnboardingViewState extends State<_FinishOnboardingView> {
  bool privacyPolicy = false;
  bool termsOfUse = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 32),
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/logo.png', height: 70)),
              Text('Switzerland',
                  style: AppFonts.custom(fontSize: 12, color: AppColors.grey)),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  child: Text('Welcome', style: AppFonts.welcome)),
              Text(
                  'Please read our privacy policy, terms of use and FAQ on www.cryptoplatz.ch before move forward.',
                  style: AppFonts.custom(fontSize: 14, color: AppColors.grey)),
              const SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'I agree and accept ',
                        style: AppFonts.custom(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://www.cryptoplatz.ch/privacy')),
                        text: 'privacy policy',
                        style: AppFonts.custom(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)
                            .copyWith(decoration: TextDecoration.underline))
                  ])),
                  CupertinoSwitch(
                      value: privacyPolicy,
                      activeColor: AppColors.red,
                      onChanged: (bool value) {
                        setState(() {
                          privacyPolicy = value;
                        });
                      })
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'I agree and accept ',
                        style: AppFonts.custom(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://www.cryptoplatz.ch/terms')),
                        text: 'terms of use',
                        style: AppFonts.custom(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)
                            .copyWith(decoration: TextDecoration.underline))
                  ])),
                  CupertinoSwitch(
                      value: termsOfUse,
                      activeColor: AppColors.red,
                      onChanged: (bool value) {
                        setState(() {
                          termsOfUse = value;
                        });
                      })
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.maxFinite,
                child: TextButton(
                    onPressed: privacyPolicy && termsOfUse
                        ? () {
                            context.read<OnboardingCubit>().finishOnboarding();

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                TabsController.routeName, (route) => false);
                          }
                        : null,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.red,
                        disabledBackgroundColor: AppColors.red.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text('Start',
                        style: AppFonts.custom(
                            fontSize: 16, color: Colors.white))),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/network.png'),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Text(
                        'To increase your security we suggest you to turn on the airplane mode on your device',
                        style: AppFonts.custom(
                            fontSize: 14, color: AppColors.grey)),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
