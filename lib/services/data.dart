import 'package:app_reminder/menu_side/enums.dart';
import 'package:app_reminder/menu_side/menu.dart';
import 'package:app_reminder/models/activity_info.dart';
import 'package:flutter/material.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.jam,
      judul: "Clock", iconSelect: Icons.access_time, colors: Color(0xFF056676)),
  MenuInfo(MenuType.reminder,
      judul: "Reminder", iconSelect: Icons.event, colors: Color(0xFFd54062)),
  MenuInfo(MenuType.catatan,
      judul: "Notes", iconSelect: Icons.note_add, colors: Color(0xFFfcbf49)),
  // MenuInfo(MenuType.progresTask,
  //     judul: "Tasks",
  //     iconSelect: Icons.check_box_rounded,
  //     colors: Color(0xFF0B7AEB)),
];

List<ActivityInfo> taskData = [
  ActivityInfo(
    title: "Halo",
    description: "tes",
    activityDateTime: DateTime.now(),
  )
];
