import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle welcome = GoogleFonts.inter(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle custom(
      {required double fontSize,
      Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal}) {
    return GoogleFonts.inter(
        fontSize: fontSize, color: color, fontWeight: fontWeight);
  }
}
