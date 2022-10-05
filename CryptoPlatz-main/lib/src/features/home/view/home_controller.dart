import 'package:crypto_platz/src/app/theme/app_colors.dart';
import 'package:crypto_platz/src/app/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends StatelessWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 62),
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/logo.png', height: 70)),
              Text('Switzerland',
                  style: AppFonts.custom(fontSize: 12, color: AppColors.grey)),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(
                        left: 60, right: 60, top: 50, bottom: 100),
                    child: Image.asset('assets/images/card.png')),
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(bottom: 20),
                child: TextButton(
                    onPressed: () {
                      launchUrl(Uri.parse('https://www.cryptoplatz.ch'));
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.red,
                        disabledBackgroundColor: AppColors.red.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text('Buy CryptoPlatz Card',
                        style: AppFonts.custom(
                            fontSize: 16, color: Colors.white))),
              ))
        ],
      ),
    ));
  }
}
