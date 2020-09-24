import 'package:app_reminder/color/colors_list.dart';
import 'package:app_reminder/models/category_info.dart';
import 'package:app_reminder/repositories/database_connection.dart';
import 'package:app_reminder/services/data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgresTaskScreen extends StatefulWidget {
  @override
  _ProgresTaskScreenState createState() => _ProgresTaskScreenState();
}

class _ProgresTaskScreenState extends State<ProgresTaskScreen> {
  double _initial = 0.0;
  int percent = 0;
  int initialValue = 0;
  int lengthValue = 0;
  bool isUpdating;
  var _titleController = TextEditingController();
  DBHelper _dbHelper = DBHelper();
  Future<List<CategoryInfo>> _categories;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _dbHelper.initDB().then((value) {
      print('------------database initialized');
      refresList();
    });
    isUpdating = false;
    super.initState();
  }

  clearForm() {
    _titleController.text = '';
  }

  refresList() {
    _categories = _dbHelper.getCategory();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
        child: Column(
          children: [
            Text(
              "My Task",
              style: TextStyle(
                fontFamily: 'HomeSchool',
                color: Colors.white,
                fontSize: 42,
                // fontWeight: FontWeight.w700
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _categories,
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
                            color: Color(0xFF0B7AEB).withOpacity(0.8),
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
                    children: snapshot.data.map<Widget>((tasks) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(tasks.title),
                                content: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView(
                                    children: taskData.map<Widget>((e) {
                                      return Card(
                                          elevation: 3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      blurRadius: 8,
                                                      spreadRadius: 4,
                                                      offset: Offset(4, 4))
                                                ]),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.check_box),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 2),
                                                      width: 190,
                                                      child: Text(
                                                          "data adwijij dwoid  ",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'Montserrat-Regular'),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                                Icon(Icons.delete)
                                              ],
                                            ),
                                          ));
                                    }).followedBy([
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 0),
                                        child: Center(
                                            child: DottedBorder(
                                                strokeWidth: 2,
                                                color: Colors.black,
                                                borderType: BorderType.RRect,
                                                radius: Radius.circular(24),
                                                dashPattern: [5, 4],
                                                child: FloatingActionButton
                                                    .extended(
                                                        onPressed: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              useRootNavigator:
                                                                  true,
                                                              isScrollControlled:
                                                                  true,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          24),
                                                                ),
                                                              ),
                                                              builder:
                                                                  (context) {
                                                                return StatefulBuilder(
                                                                    builder:
                                                                        (context,
                                                                            setModalState) {
                                                                  return SingleChildScrollView(
                                                                      child: Form(
                                                                          key: formKey,
                                                                          child: Container(
                                                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 32, right: 32, left: 32),
                                                                              child: Column(children: [
                                                                                TextFormField(
                                                                                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Title'),
                                                                                ),
                                                                                SizedBox(height: 10),
                                                                                FloatingActionButton.extended(
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    label: Text('Save')),
                                                                                SizedBox(height: 60),
                                                                              ]))));
                                                                });
                                                              });
                                                        },
                                                        icon: Icon(Icons.add),
                                                        label: Text('Add')))),
                                      )
                                    ]).toList(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.only(bottom: 25),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: GradientColors.skyBlue,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight),
                                boxShadow: [
                                  BoxShadow(
                                      color: GradientColors.skyBlue.last
                                          .withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 4,
                                      offset: Offset(4, 4))
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tasks.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontFamily: 'Montserrat-Regular',
                                          ),
                                        ),
                                        Text(
                                          '$initialValue of $lengthValue',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Montserrat-Regular',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LinearPercentIndicator(
                                          lineHeight: 15.0,
                                          percent: _initial,
                                          center: Text(
                                            "$percent%",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Color(0xFFD5D5D5),
                                          progressColor: Color(0xFF6CA2B5),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Delete'),
                                                    content: Text(
                                                        "Are you sure want to delete this task?",
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                    actions: [
                                                      FloatingActionButton
                                                          .extended(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        label: Text('No'),
                                                        backgroundColor:
                                                            Colors.lightBlue,
                                                        icon: Icon(Icons
                                                            .highlight_off),
                                                      ),
                                                      FloatingActionButton
                                                          .extended(
                                                        onPressed: () async {
                                                          _dbHelper
                                                              .deleteCategory(
                                                                  tasks.id);
                                                          Navigator.of(context)
                                                              .pop();
                                                          refresList();
                                                        },
                                                        label: Text('Yes'),
                                                        backgroundColor:
                                                            Colors.red,
                                                        icon: Icon(Icons
                                                            .check_circle_outline),
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 25,
                                          ))
                                    ],
                                  ),
                                ])),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Form(
                child: AlertDialog(
                  title: Text('Add Title'),
                  content: TextFormField(
                    controller: _titleController,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  actions: [
                    FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.cancel_outlined, color: Colors.black),
                        backgroundColor: Colors.redAccent,
                        label: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        )),
                    FloatingActionButton.extended(
                        onPressed: () {
                          var categoryInfo =
                              CategoryInfo(title: _titleController.text);
                          _dbHelper.insertCategory(categoryInfo);
                          refresList();
                          clearForm();
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.save),
                        backgroundColor: Colors.blueAccent,
                        label: Text('Save')),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
        backgroundColor: Color(0xFF0B7AEB),
      ),
    );
  }
}
