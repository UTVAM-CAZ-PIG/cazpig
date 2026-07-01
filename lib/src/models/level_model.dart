import 'package:flutter/material.dart';

class MixLevelModel {
  final int level;
  final String objective;
  final Color colorHex;
  final String instruction;
  final Color color1;
  final Color color2;

  MixLevelModel({
    required this.level,
    required this.objective,
    required this.colorHex,
    required this.instruction,
    required this.color1,
    required this.color2,
  });
}

class SearchLevelModel {
  final int level;
  final String context;
  final String brief;
  final Color correctColor;
  final String colorName;

  SearchLevelModel({
    required this.level,
    required this.context,
    required this.brief,
    required this.correctColor,
    required this.colorName,
  });
}

class GradientLevelModel {
  final int level;
  final List<Color> sequence;
  final Color correctColor;
  final String colorName;

  GradientLevelModel({
    required this.level,
    required this.sequence,
    required this.correctColor,
    required this.colorName,
  });
}
