import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto_platz/src/app/repositories/crypto_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

part 'restore_state.dart';

class RestoreCubit extends Cubit<RestoreState> {
  RestoreCubit({required this.cryptoRepository}) : super(const RestoreState());

  final CryptoRepository cryptoRepository;

  void changePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void setLock(bool value) {
    emit(state.copyWith(unlockCard: value));
  }

  void hideDialog() {
    emit(state.copyWith(showDialog: false));
  }

  void showPassword(bool value) {
    emit(state.copyWith(showPassword: value));
  }

  void clear() {
    emit(state.copyWith(password: '', unlockCard: false));
  }

  Future<void> readNFCTag() async {
    NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            Ndef? ndef = Ndef.from(tag);

            if (ndef != null) {
              NdefMessage? message = await ndef.read();

              String data = utf8.decode(message.records[0].payload);

              bool password = message.records.length > 1 &&
                  message.records[1].payload[0] == 1;

              if (password) {
                try {
                  String result =
                      await cryptoRepository.decrypt(data, state.password);

                  if (state.unlockCard) {
                    Uint8List passwordData =
                        cryptoRepository.hashPassword(state.password);

                    int maxSize = ndef.maxSize;

                    int configPage = cryptoRepository.getPage(maxSize);

                    if (Platform.isIOS) {
                      await MiFare.from(tag)!.sendMiFareCommand(
                          Uint8List.fromList([
                        0x1B,
                        passwordData[0],
                        passwordData[1],
                        passwordData[2],
                        passwordData[3]
                      ]));

                      await MiFare.from(tag)!.sendMiFareCommand(
                          Uint8List.fromList(
                              [0xA2, configPage, 0, 0, 0, 0xFF]));
                    } else {
                      await MifareUltralight.from(tag)!.transceive(
                          data: Uint8List.fromList([
                        0x1B,
                        passwordData[0],
                        passwordData[1],
                        passwordData[2],
                        passwordData[3]
                      ]));

                      await MifareUltralight.from(tag)!.transceive(
                          data: Uint8List.fromList(
                              [0xA2, configPage, 0, 0, 0, 0xFF]));
                    }
                  }

                  data = result;
                } catch (_) {
                  await NfcManager.instance.stopSession(errorMessage: 'Error');

                  emit(state.copyWith(isPasswordError: true));
                  emit(state.copyWith(isPasswordError: false));

                  return;
                }
              }

              await NfcManager.instance.stopSession();

              emit(state.copyWith(result: data, showDialog: true));

              emit(state.copyWith(showDialog: false));
            }
          } catch (_) {
            emit(state.copyWith(isConnectionError: true));

            emit(state.copyWith(isConnectionError: false));

            await NfcManager.instance.stopSession(errorMessage: 'Error');
          }
        },
        pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693},
        onError: (error) async {
          if (error.type != NfcErrorType.userCanceled) {
            emit(state.copyWith(isConnectionError: true));

            emit(state.copyWith(isConnectionError: false));

            await NfcManager.instance.stopSession(errorMessage: 'Error');
          }
        });
  }
}
