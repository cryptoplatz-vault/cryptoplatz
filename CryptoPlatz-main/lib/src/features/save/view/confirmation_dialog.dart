import 'package:crypto_platz/src/app/theme/app_colors.dart';
import 'package:crypto_platz/src/app/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 65,
              width: 65,
              decoration: const BoxDecoration(
                  color: AppColors.red, shape: BoxShape.circle),
              child: const Icon(Icons.done_rounded,
                  color: Colors.white, size: 40)),
          const SizedBox(height: 20),
          Text('Success', style: AppFonts.custom(fontSize: 16)),
          const SizedBox(height: 9),
          Text('Information is safe now',
              style: AppFonts.custom(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 30),
          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Done',
                    style: AppFonts.custom(fontSize: 16, color: Colors.white))),
          )
        ],
      ),
    );
  }
}
