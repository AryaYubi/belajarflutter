// lib/theme.dart (Perbaikan Duplikasi dan Penambahan alertTextStyle)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = 30.0;

Color primaryColor = Color(0xff6C5ECF);
Color secondaryColor = Color(0xff38ABBE);
Color alertColor = Color(0xffED6363); // Ini adalah satu-satunya deklarasi alertColor
Color priceColor = Color(0xff2C96F1);
Color bg1Color = Color(0xff1F1D2B);
Color bg2Color = Color(0xff2B2937);
Color bg3Color = Color(0xff242231);
Color primaryTextColor = Color(0xffF1F0F2);
Color secondaryTextColor = Color(0xff999999);
Color subtitleTextColor = Color(0xff504F5E);

TextStyle primaryTextStyle = GoogleFonts.poppins(color: primaryTextColor);

TextStyle secondaryTextStyle = GoogleFonts.poppins(color: secondaryTextColor);

TextStyle priceTextStyle = GoogleFonts.poppins(color: priceColor);

TextStyle subtitleTextStyle = GoogleFonts.poppins(color: subtitleTextColor);

TextStyle purpleTextStyle = GoogleFonts.poppins(color: primaryColor);

// Penambahan yang hilang
TextStyle alertTextStyle = GoogleFonts.poppins(color: alertColor); 

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;