import 'package:crypto_platz/src/app/theme/app_colors.dart';
import 'package:crypto_platz/src/app/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataDialog extends StatelessWidget {
  const DataDialog({required this.data, super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data restored',
                style:
                    AppFonts.custom(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Don\'t let other person see your screen',
                style: AppFonts.custom(fontSize: 16)),
            const SizedBox(height: 30),
            Text(data, style: AppFonts.custom(fontSize: 16)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.maxFinite,
              child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: data));

                    Navigator.of(context).pop();
                  },
                  child: Text('Copy',
                      style:
                          AppFonts.custom(fontSize: 16, color: Colors.white))),
            )
          ],
        ),
      ),
    );
  }
}
