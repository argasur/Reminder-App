import 'dart:math';
import 'dart:typed_data';
import 'package:app_reminder/color/colors_list.dart';
import 'package:app_reminder/models/activity_info.dart';
import 'package:app_reminder/repositories/database_connection.dart';
import 'package:app_reminder/services/notification_pulgin.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime _activityDate;
  DateTime _activityUpdate;
  String _activityTimeString;
  String _activityDateString;
  String _dateString;
  String _titleString;
  String _descString;
  var _titleController = TextEditingController();
  var _descController = TextEditingController();
  var _dateController = TextEditingController();
  DBHelper _dbHelper = DBHelper();
  Future<List<ActivityInfo>> _activities;
  bool isUpdating;
  int idActivity;
  int _uniqcode;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _activityDate = DateTime.now();
    _dbHelper.initDB().then((value) {
      print('------------database initialized');
      refresList();
    });
    isUpdating = false;
    super.initState();
  }

  clearForm() {
    _titleController.text = '';
    _descController.text = '';
    _dateController.text = '';
  }

  refresList() {
    _activities = _dbHelper.getAvtivity();
    if (mounted) setState(() {});
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      int _id;
      String _title;
      String _deskription;
      DateTime scheduleDateTime;
      if (isUpdating) {
        if (_activityDate.isAfter(DateTime.now()) && _activityDate != null) {
          scheduleDateTime = _activityDate;
          _id = _uniqcode;
          _title = _titleController.text;
          _deskription = _descController.text;
        } else {
          scheduleDateTime = _activityUpdate;
          _id = _uniqcode;
          _title = _titleController.text;
          _deskription = _descController.text;
        }
        var activityInfo = ActivityInfo(
            id: idActivity,
            title: _titleController.text,
            description: _descController.text,
            activityDateTime: scheduleDateTime,
            isPending: _id);
        _dbHelper.updateActivity(activityInfo);
        setState(() {
          isUpdating = false;
        });
        scheduleReminder(_id, _title, _deskription, scheduleDateTime);
      } else {
        int _uniqCode = Random().nextInt(1000);
        if (_activityDate.isAfter(DateTime.now()) && _activityDate != null) {
          scheduleDateTime = _activityDate;
          _id = _uniqCode;
          _title = _titleController.text;
          _deskription = _descController.text;
          var activityInfo = ActivityInfo(
              title: _titleString,
              description: _descString,
              activityDateTime: scheduleDateTime,
              isPending: _id);
          _dbHelper.insertActivity(activityInfo);
          scheduleReminder(_id, _title, _deskription, scheduleDateTime);
        } else {}
      }
      Navigator.of(context).pop();
      refresList();
      clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Appointment",
              style: TextStyle(
                fontFamily: 'HomeSchool',
                color: Colors.white,
                fontSize: 42,
                // fontWeight: FontWeight.w700
              ),
            ),
            Expanded(
                child: FutureBuilder(
              future: _activities,
              builder: (context, snapshot) {
                if (null == snapshot.data || snapshot.data.length == 0) {
                  return Center(
                      child: DottedBorder(
                    strokeWidth: 2,
                    color: Colors.white,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(24),
                    dashPattern: [5, 4],
                    child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFFd54062).withOpacity(0.8),
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Center(
                          child: Text(
                            'Data Not Found',
                            style: TextStyle(
                                fontFamily: 'Montserrat-Regular',
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        )),
                  ));
                }
                return ListView(
                    children: snapshot.data.map<Widget>((activity) {
                  var activityTime =
                      DateFormat('hh:mm aa').format(activity.activityDateTime);
                  var activitydate = DateFormat('E, dd MMM yyyy')
                      .format(activity.activityDateTime);
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        isUpdating = true;
                        idActivity = activity.id;
                        _uniqcode = activity.isPending;
                        _activityUpdate = activity.activityDateTime;
                      });
                      _titleController.text = activity.title;
                      _descController.text = activity.description;
                      _activityTimeString = DateFormat('HH:mm a')
                          .format(activity.activityDateTime);
                      _activityDateString = DateFormat('dd/MM/yyyy')
                          .format(activity.activityDateTime);
                      _dateController.text = DateFormat('dd/MM/yyyy HH:mm')
                          .format(activity.activityDateTime);
                      await buildShowModalBottomSheet(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 25),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: GradientColors.fire,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    GradientColors.fire.last.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 4,
                                offset: Offset(4, 4))
                          ],
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.label,
                                      size: 22, color: Colors.white),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    activity.title,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-Regular',
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            activitydate,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat-Regular'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activityTime,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-Regular',
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Delete"),
                                          content: Text(
                                              "Are you sure want to delete this appointment?",
                                              style: TextStyle(fontSize: 18)),
                                          actions: [
                                            FloatingActionButton.extended(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                print(activity.isPending);
                                              },
                                              label: Text('No'),
                                              backgroundColor: Colors.lightBlue,
                                              icon: Icon(Icons.highlight_off),
                                            ),
                                            FloatingActionButton.extended(
                                              onPressed: () async {
                                                _dbHelper.deleteActivity(
                                                    activity.id);
                                                Navigator.of(context).pop();
                                                refresList();
                                                return await notificationPlugin
                                                    .flutterLocalNotificationsPlugin
                                                    .cancel(activity.isPending);
                                              },
                                              label: Text('Yes'),
                                              backgroundColor: Colors.red,
                                              icon: Icon(
                                                  Icons.check_circle_outline),
                                            )
                                          ],
                                        );
                                      });
                                },
                                iconSize: 25,
                                color: Colors.white,
                                icon: Icon(
                                  Icons.delete,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }).toList());
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _activityDate = DateTime.now();
          });
          _activityTimeString = DateFormat('HH:mm a').format(DateTime.now());
          _activityDateString = DateFormat('dd/MM/yyyy').format(DateTime.now());
          await buildShowModalBottomSheet(context);
        },
        child: Icon(Icons.add, size: 40),
        backgroundColor: Color(0xFFd54062),
      ),
    );
  }

  buildShowModalBottomSheet(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        clipBehavior: Clip.antiAlias,
        useRootNavigator: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 32,
                      right: 32,
                      left: 32),
                  child: Column(
                    children: [
                      Text(
                        "Set Time :",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat-Regular'),
                      ),
                      SizedBox(height: 10),
                      FlatButton(
                          onPressed: () async {
                            var selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2050));
                            var selectedTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (selectedDate != null && selectedTime != null) {
                              var selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute);
                              _activityDate = selectedDateTime;
                              setModalState(() {
                                _activityTimeString = DateFormat('HH:mm a')
                                    .format(selectedDateTime);
                                _activityDateString = DateFormat('dd/MM/yyyy')
                                    .format(selectedDateTime);
                                _dateController.text =
                                    DateFormat('dd/MM/yyyy HH:mm')
                                        .format(selectedDateTime);
                              });
                            }
                          },
                          child: Column(
                            children: [
                              Text(_activityTimeString,
                                  style: TextStyle(fontSize: 28)),
                              Text(_activityDateString,
                                  style: TextStyle(fontSize: 18)),
                            ],
                          )),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (val) =>
                            val.length == 0 ? 'Enter Title' : null,
                        onSaved: (val) => _titleString = val,
                        controller: _titleController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Title'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (val) =>
                            val.length == 0 ? 'Enter Description' : null,
                        onSaved: (val) => _descString = val,
                        controller: _descController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description'),
                      ),
                      SizedBox(height: 40),
                      FloatingActionButton.extended(
                          onPressed: validate,
                          icon: Icon(Icons.alarm_add),
                          label: Text(isUpdating ? 'Update' : 'Save')),
                      SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> scheduleReminder(
      int id, String title, String deskripsi, DateTime time) async {
    var scheduleNotificationDateTime = time;
    var _title = title;
    var _id = id;
    var _deskripsi = deskripsi;
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var androidPlatformChannelSpesifics = AndroidNotificationDetails(
      'remind_notif',
      'remind_notif',
      'Channel for Remind Notif',
      icon: 'app_icon',
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      importance: Importance.Max,
      priority: Priority.High,
      vibrationPattern: vibrationPattern,
    );
    var iOSPlatformChannelSpesifics = IOSNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );
    var platformChannelSpesifics = NotificationDetails(
        androidPlatformChannelSpesifics, iOSPlatformChannelSpesifics);
    await notificationPlugin.flutterLocalNotificationsPlugin.schedule(
        _id,
        _title,
        _deskripsi,
        scheduleNotificationDateTime,
        platformChannelSpesifics,
        payload: _deskripsi,
        androidAllowWhileIdle: true);
  }
}
