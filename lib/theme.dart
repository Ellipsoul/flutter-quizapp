import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Customise app theme here!
var appTheme = ThemeData(
  // Apply a custom font from imported Google fonts
  fontFamily: GoogleFonts.nunito().fontFamily,
  // Sets the bottom bar to a darkish mode
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.black87,
  ),
  brightness: Brightness.dark,
  // Overriding default settings
  textTheme: const TextTheme(
    bodyText1: TextStyle(fontSize: 18),
    bodyText2: TextStyle(fontSize: 16),
    button: TextStyle(
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
    ),
    headline1: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    subtitle1: TextStyle(
      color: Colors.grey,
    ),
  ),
  buttonTheme: const ButtonThemeData(),
);
