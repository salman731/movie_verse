

import 'dart:ui';

class CustomColor extends Color
{

  CustomColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    String _hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (_hexColor.length == 6) {
      _hexColor = "FF$_hexColor";
    }
    return int.parse(_hexColor, radix: 16);
  }
}


class AppColors
{
  static final Color kPrimaryColor = CustomColor("#e31717");
}

