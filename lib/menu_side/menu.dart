import 'package:app_reminder/menu_side/enums.dart';
import 'package:flutter/material.dart';

class MenuInfo extends ChangeNotifier {
  MenuType menuType;
  String judul;
  IconData iconSelect;
  Color colors;

  MenuInfo(this.menuType, {this.judul, this.iconSelect, this.colors});

  menuUpdate(MenuInfo menuInfo) {
    this.menuType = menuInfo.menuType;
    this.judul = menuInfo.judul;
    this.iconSelect = menuInfo.iconSelect;
    this.colors = menuInfo.colors;

    // important
    notifyListeners();
  }
}
