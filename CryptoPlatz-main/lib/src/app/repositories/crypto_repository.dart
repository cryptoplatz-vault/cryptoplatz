import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';

class CryptoRepository {
  final AesGcm algorithm = AesGcm.with256bits();

  Future<String> encrypt(String data, String password) async {
    final List<int> nonce = algorithm.newNonce();

    final List<int> hashedPassword =
        utf8.encode(md5.convert(utf8.encode(password)).toString());

    final SecretKey secretKey =
        await algorithm.newSecretKeyFromBytes(hashedPassword);

    final SecretBox box = await algorithm.encrypt(utf8.encode(data),
        nonce: nonce, secretKey: secretKey);

    return hex.encode(box.nonce + box.cipherText + box.mac.bytes);
  }

  Uint8List hashPassword(String password) {
    final List<int> hashedPassword =
        utf8.encode(md5.convert(utf8.encode(password)).toString());

    return Uint8List.fromList(hashedPassword);
  }

  Future<String> decrypt(String input, String password) async {
    final List<int> data = hex.decode(input);

    final List<int> nonce = data.sublist(0, 12);
    final List<int> mac = data.sublist(data.length - 16);
    final List<int> text = data.sublist(12, data.length - 16);

    final SecretBox box = SecretBox(text, nonce: nonce, mac: Mac(mac));

    final List<int> hashedPassword =
        utf8.encode(md5.convert(utf8.encode(password)).toString());

    final SecretKey secretKey =
        await algorithm.newSecretKeyFromBytes(hashedPassword);

    final List<int> result = await algorithm.decrypt(box, secretKey: secretKey);

    return utf8.decode(result);
  }

  int getPage(int size) {
    switch (size) {
      case 137:
        return 0x29;
      case 492:
        return 0x83;
      case 868:
        return 0xE3;
      default:
        return 0x83;
    }
  }
}
