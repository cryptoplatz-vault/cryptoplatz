import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto_platz/src/app/repositories/crypto_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

part 'save_state.dart';

class SaveCubit extends Cubit<SaveState> {
  SaveCubit({required this.cryptoRepository}) : super(const SaveState());

  final CryptoRepository cryptoRepository;

  void changeData(String data) {
    emit(state.copyWith(data: data));
  }

  void changePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void changeConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  void setProtectData(bool value) {
    emit(state.copyWith(protectData: value));
  }

  void hideDialog() {
    emit(state.copyWith(showDialog: false));
  }

  void showPassword(bool value) {
    emit(state.copyWith(showPassword: value));
  }

  void clear() {
    emit(state.copyWith(
        password: '', confirmPassword: '', data: '', protectData: false));
  }

  Future<void> save() async {
    writeNFCTag();
  }

  Future<void> writeNFCTag() async {
    await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            Ndef? ndef = Ndef.from(tag);

            if (ndef != null) {
              if (state.protectData && state.isPasswordValid) {
                int maxSize = ndef.maxSize;

                int configPage = cryptoRepository.getPage(maxSize);

                Uint8List password =
                    cryptoRepository.hashPassword(state.password);

                if (Platform.isIOS) {
                  Uint8List response = await MiFare.from(tag)!
                      .sendMiFareCommand(
                          Uint8List.fromList([0x30, configPage]));

                  await MiFare.from(tag)!.sendMiFareCommand(Uint8List.fromList([
                    0xA2,
                    configPage + 3,
                    1,
                    2,
                    response[14],
                    response[15]
                  ]));

                  await MiFare.from(tag)!.sendMiFareCommand(Uint8List.fromList([
                    0xA2,
                    configPage + 2,
                    password[0],
                    password[1],
                    password[2],
                    password[3]
                  ]));

                  await MiFare.from(tag)!.sendMiFareCommand(Uint8List.fromList([
                    0xA2,
                    configPage,
                    response[0],
                    response[1],
                    response[2],
                    4
                  ]));
                } else {
                  Uint8List response = await MifareUltralight.from(tag)!
                      .transceive(data: Uint8List.fromList([0x30, configPage]));

                  await MifareUltralight.from(tag)!.transceive(
                      data: Uint8List.fromList([
                    0xA2,
                    configPage + 3,
                    1,
                    2,
                    response[14],
                    response[15]
                  ]));

                  await MifareUltralight.from(tag)!.transceive(
                      data: Uint8List.fromList([
                    0xA2,
                    configPage + 2,
                    password[0],
                    password[1],
                    password[2],
                    password[3]
                  ]));

                  await MifareUltralight.from(tag)!.transceive(
                      data: Uint8List.fromList([
                    0xA2,
                    configPage,
                    response[0],
                    response[1],
                    response[2],
                    4
                  ]));
                }
              }

              if (state.password.isNotEmpty && state.isConfirmPasswordValid) {
                String result =
                    await cryptoRepository.encrypt(state.data, state.password);

                emit(state.copyWith(data: result));
              }

              NdefRecord record = NdefRecord(
                typeNameFormat: NdefTypeNameFormat.nfcWellknown,
                type: Uint8List.fromList([0x54]),
                identifier: Uint8List.fromList([]),
                payload: Uint8List.fromList(
                  utf8.encode(state.data),
                ),
              );

              NdefRecord password = NdefRecord(
                typeNameFormat: NdefTypeNameFormat.nfcWellknown,
                type: Uint8List.fromList([0x54]),
                identifier: Uint8List.fromList([]),
                payload:
                    Uint8List.fromList([state.password.isNotEmpty ? 1 : 0]),
              );

              await ndef.write(NdefMessage([record, password]));

              await NfcManager.instance.stopSession();

              emit(state.copyWith(
                  showDialog: true,
                  data: '',
                  password: '',
                  confirmPassword: '',
                  protectData: false));

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
