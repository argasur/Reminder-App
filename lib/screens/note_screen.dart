import 'package:app_reminder/models/notes_info.dart';
import 'package:app_reminder/repositories/database_connection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  var _titleController = TextEditingController();
  var _descController = TextEditingController();
  bool isUpdating;
  int _id;

  DBHelper _dbHelper = DBHelper();
  Future<List<NotesInfo>> _notes;
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
    _descController.text = '';
  }

  refresList() {
    _notes = _dbHelper.getNotes();
    if (mounted) setState(() {});
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        var notesInfo = NotesInfo(
            id: _id,
            title: _titleController.text,
            description: _descController.text);
        _dbHelper.updateNotes(notesInfo);
        setState(() {
          isUpdating = false;
        });
      } else {
        var notesInfo = NotesInfo(
            title: _titleController.text, description: _descController.text);
        _dbHelper.inserNotes(notesInfo);
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
          children: [
            Text("My Notes",
                style: TextStyle(
                    fontFamily: 'CuteNotes',
                    color: Colors.white,
                    fontSize: 50)),
            Expanded(
              child: FutureBuilder(
                future: _notes,
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
                            color: Color(0xFFfcbf49).withOpacity(0.8),
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
                      children: snapshot.data.map<Widget>((notes) {
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          isUpdating = true;
                          _id = notes.id;
                        });
                        _titleController.text = notes.title;
                        _descController.text = notes.description;
                        await buildShowDialog(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        child: Card(
                          elevation: 5,
                          color: Color(0xFFfcbf49),
                          shadowColor: Color(0xFF003049),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      notes.title,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-Regular',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: IconButton(
                                        iconSize: 30,
                                        color: Color(0xFFd54062),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Delete'),
                                                  content: Text(
                                                      "Are you sure want to delete this note?",
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
                                                      icon: Icon(
                                                          Icons.highlight_off),
                                                    ),
                                                    FloatingActionButton
                                                        .extended(
                                                      onPressed: () async {
                                                        _dbHelper.deleteNotes(
                                                            notes.id);
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
                                        icon: Icon(Icons.delete)),
                                  )
                                ],
                              ),
                              Container(
                                height: 150,
                                width: 300,
                                color: Color(0xFFeae2b7),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Text(
                                  notes.description,
                                  maxLines: 10,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList());
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await buildShowDialog(context);
        },
        child: Icon(Icons.add, size: 40),
        backgroundColor: Color(0xFFfcbf49),
      ),
    );
  }

  Future buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: formKey,
            child: AlertDialog(
              title: TextField(
                controller: _titleController,
                autocorrect: true,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              content: Container(
                color: Color(0xFFeae2b7),
                child: TextField(
                  controller: _descController,
                  autocorrect: true,
                  maxLines: 10,
                  decoration: InputDecoration(
                      hintText: 'Write something..',
                      border: OutlineInputBorder()),
                ),
              ),
              actions: [
                FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.cancel_outlined, color: Colors.black),
                    backgroundColor: Colors.redAccent,
                    label: Text(
                      'Discard',
                      style: TextStyle(color: Colors.black),
                    )),
                FloatingActionButton.extended(
                    onPressed: validate,
                    icon: Icon(Icons.save),
                    backgroundColor: Colors.blueAccent,
                    label: Text(isUpdating ? 'Update' : 'Save')),
              ],
            ),
          );
        });
  }
}
