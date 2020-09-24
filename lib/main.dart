import 'package:app_reminder/menu_side/enums.dart';
import 'package:app_reminder/menu_side/menu.dart';
import 'package:app_reminder/screens/dashboard_screen.dart';
import 'package:app_reminder/screens/reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<MenuInfo>(
          create: (context) => MenuInfo(MenuType.jam),
          child: DashboardScreen()),
    );
  }
}
