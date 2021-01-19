import 'package:flutter/material.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';

class ClothingPickingList {
  // TODO: Tee size
  static const List<String> TeeSize = [
    'NB',
    '3M',
    '6M',
    '9M',
    '12M',
    '18M',
    '24M'
  ];

  //TODO: Pant size
  static const List<String> PantSize = [
    '3-6 M',
    '9-12 M',
    '12-18 M',
    '18-24 M',
    '2T',
    '3T',
    '4T'
  ];

//TODO: Shoes size
  static const List<String> ShoesSize = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8'
  ];

  //TODO: list color
  static const List<String> ColorList = [
    'Black',
    'White',
    'Grey',
    'Red',
    'Blue',
    'Yellow',
    'Orange',
    'Pink',
    'Brown',
    'Purple',
    'Cyan',
    'Green'
  ];

//TODO: Convert ColorList value to Color
  Color getColorFromColorList(String value) {
    switch (value) {
      case 'Black':
        return kColorBlack;
      case 'White':
        return kColorWhite;
      case 'Grey':
        return kColorGrey;
      case 'Red':
        return kColorRed;
      case 'Blue':
        return kColorBlue;
      case 'Yellow':
        return kColorYellow;
      case 'Orange':
        return kColorOrange;
      case 'Pink':
        return kColorPink;
      case 'Brown':
        return kColorBrown;
      case 'Purple':
        return kColorPurple;
      case 'Cyan':
        return kColorCyan;
      case 'Green':
        return kColorGreen;
      default:
        return kColorWhite;
    }
  }
}
