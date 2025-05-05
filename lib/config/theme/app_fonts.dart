import 'app_colors.dart';
import 'package:flutter/material.dart';

class AppFont {
  static final regular = TextStyle(
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w400,
    color: AppColors.drak,

  );
  static final semi = TextStyle(
    fontFamily: 'Actor',
    fontWeight: FontWeight.w400,
    color: AppColors.drak,
  );
  // regular
  static final regular_default_10 = regular.copyWith(fontSize: 10);
  static final regular_default_12 = regular.copyWith(fontSize: 12);
  static final regular_default_14 = regular.copyWith(fontSize: 14);
  static final regular_default_16 = regular.copyWith(fontSize: 16);
  static final regular_default_18 = regular.copyWith(fontSize: 18);
  static final regular_default_20 = regular.copyWith(fontSize: 20);
  static final regular_default_22 = regular.copyWith(fontSize: 22);
  // semi
  static final semi_default_10 = semi.copyWith(fontSize: 10);
  static final semi_default_12 = semi.copyWith(fontSize: 12);
  static final semi_default_14 = semi.copyWith(fontSize: 14);
  static final semi_default_16 = semi.copyWith(fontSize: 16);
  static final semi_default_18 = semi.copyWith(fontSize: 18);
  static final semi_default_20 = semi.copyWith(fontSize: 20);
}
