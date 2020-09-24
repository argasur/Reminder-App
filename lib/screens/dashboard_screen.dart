import 'dart:async';
import 'dart:math';
import 'package:app_reminder/screens/note_screen.dart';
import 'package:app_reminder/screens/progressTask_screen.dart';
import 'package:app_reminder/services/data.dart';
import 'package:app_reminder/menu_side/enums.dart';
import 'package:app_reminder/menu_side/menu.dart';
import 'package:app_reminder/screens/reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatJam = DateFormat('HH:mm a').format(DateTime.now());
    var formatTanggal = DateFormat('dd MMMM yyyy').format(DateTime.now());
    var formatHari = DateFormat('EEEEE').format(DateTime.now());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF206a5d), Color(0xFF229396)],
                begin: FractionalOffset(0.5, 1))),
        child: Row(
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: menuItems
                    .map((currentMenuInfo) => buildMenuButton(currentMenuInfo))
                    .toList()),
            VerticalDivider(
              color: Colors.white54,
              width: 1,
            ),
            Expanded(
              child: Consumer<MenuInfo>(builder:
                  (BuildContext context, MenuInfo value, Widget child) {
                if (value.menuType == MenuType.jam)
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 15, top: 50),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 4,
                            child: Column(
                              children: [
                                Text(
                                  formatTanggal,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      fontSize: 22,
                                      color: Colors.white),
                                ),
                                Text(
                                  formatHari,
                                  style: TextStyle(
                                      fontFamily: 'PaperSticker',
                                      fontSize: 45,
                                      color: Colors.white),
                                ),
                              ],
                            )),
                        Container(
                            alignment: Alignment.center,
                            child: Transform.rotate(
                              angle: -pi / 2,
                              child: Container(
                                  width: 250,
                                  height: 250,
                                  child: CustomPaint(
                                    painter: ClockPainter(),
                                  )),
                            )),
                        SizedBox(height: 40),
                        Container(
                          width: 250,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 4,
                                    offset: Offset(4, 4))
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF056676),
                              border: Border.all(
                                  color: Color(0xFFe8ded2), width: 5)),
                          child: Center(
                            child: Text(
                              formatJam,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-Regular',
                                  fontSize: 40,
                                  color: Color(0xFFfcdab7)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                else if (value.menuType == MenuType.reminder)
                  return ReminderScreen();
                else
                  return NotesScreen();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child) {
        return FlatButton(
          color: currentMenuInfo.menuType == value.menuType
              ? currentMenuInfo.colors
              : Colors.transparent,
          onPressed: () {
            var menuInfo = Provider.of<MenuInfo>(context, listen: false);
            menuInfo.menuUpdate(currentMenuInfo);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
            child: Column(
              children: [
                Icon(
                  currentMenuInfo.iconSelect,
                  color: Colors.white,
                  size: 45,
                ),
                Text(
                  currentMenuInfo.judul,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Montserrat-Regular',
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();
  // 60 detik = 360 derajat -> 1 detik = 6 derajat
  // 12 jam = 360 derajat -> 1 jam = 30 derajat
  // 1 min = 0.5 derajat
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()..color = Color(0xFF056676);
    var outLineBrush = Paint()
      ..color = Color(0xFFe8ded2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 250 / 20;
    var centerBrush = Paint()..color = Color(0xFFe8ded2);
    var secHandBrush = Paint()
      ..color = Color(0xFFa3d2ca)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 250 / 60;
    var minHandBrush = Paint()
      ..shader = RadialGradient(colors: [Color(0xFFffc93c), Colors.pinkAccent])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 250 / 30;

    var hourHandBrush = Paint()
      ..shader = RadialGradient(colors: [Colors.redAccent, Colors.blueAccent])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 250 / 24;

    var dashBrush = Paint()
      ..color = Color(0xFFa3d2ca)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius * 0.75, fillBrush);
    canvas.drawCircle(center, radius * 0.75, outLineBrush);
    var hourHandX = centerX +
        radius *
            0.4 *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerX +
        radius *
            0.4 *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);
    var minHandX = centerX + radius * 0.6 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerX + radius * 0.6 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);
    var secHandX = centerX + radius * 0.6 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerX + radius * 0.6 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, radius * 0.12, centerBrush);

    var outerCircleRadius = radius;
    var innerCircleRadius = radius * 0.9;
    for (double i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
