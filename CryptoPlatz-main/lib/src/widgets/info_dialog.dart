import 'package:crypto_platz/src/app/theme/app_colors.dart';
import 'package:crypto_platz/src/app/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key, required this.type, this.onConfirm});

  final DialogType type;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.only(top: 30, bottom: 17),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 42, right: 18),
                child: Text(type.messageText(),
                    style:
                        AppFonts.custom(fontSize: 12, color: AppColors.grey)),
              ),
              const SizedBox(height: 17),
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 175,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(type.buttonText(),
                          style: AppFonts.custom(
                              fontSize: 16, color: Colors.white))),
                ),
              ),
              if (type == DialogType.save)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 175,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('Cancel',
                            style: AppFonts.custom(
                                fontSize: 16, color: Colors.white))),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

enum DialogType { protect, unlock, error, password, save }

extension DialogText on DialogType {
  String messageText() {
    switch (this) {
      case DialogType.protect:
        return 'While this option is activated, you can only erase or change the data on your CryptoPlatz Vault by using your defined password.\n\nOnly with the password you can add new data or erase previous information on the vault.';
      case DialogType.unlock:
        return 'This option will remove the password protection of the CryptoPlatz Vault. Any person with access to the vault can add or erase information! Be careful!';
      case DialogType.error:
        return 'Error to communicate with the Vault. Hold the card in front of the smartphone screen and try again.';
      case DialogType.password:
        return 'Wrong password. Data couldn\'t be decrypted.';
      case DialogType.save:
        return 'Warning! Without a password the information will be not encrypted. Everyone that have access to the vault will be able to read the information. Do you want to save without a password?';
    }
  }

  String buttonText() {
    switch (this) {
      case DialogType.protect:
        return 'I understand';
      case DialogType.unlock:
        return 'I understand';
      case DialogType.error:
        return 'OK';
      case DialogType.password:
        return 'OK';
      case DialogType.save:
        return 'Save';
    }
  }
}
