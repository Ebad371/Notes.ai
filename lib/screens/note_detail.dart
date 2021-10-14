import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper_app/models/note.dart';
import 'package:note_keeper_app/screens/new_screen.dart';
import 'package:note_keeper_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:clipboard/clipboard.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);

  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text =
      'Press the Mic icon and start speaking or write in the description';
  double _confidence = 1.0;
  String name = '';
  static var _priorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  String appBarTitle;
  Note note;
  _NoteDetailState(this.note, this.appBarTitle);
  TextEditingController descriptionController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 70,
            height: 70,
            child: AvatarGlow(
              animate: _isListening,
              glowColor: Colors.red[700],
              endRadius: 50.0,
              repeat: true,
              duration: const Duration(milliseconds: 2000),
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: Material(
                // Replace this child with your own
                elevation: 28.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    color: Colors.red[900],
                    onPressed: () {
                      _listen();
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 40,
            height: 40,
            child: Material(
              elevation: 28.0,
              shape: CircleBorder(),
              child: FloatingActionButton(
                child: Icon(
                  Icons.save,
                ),
                onPressed: () {
                  _save();
                },
                heroTag: null,
                backgroundColor: Colors.red[900],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 40,
            height: 40,
            child: Material(
              elevation: 28.0,
              shape: CircleBorder(),
              child: FloatingActionButton(
                child: Icon(Icons.delete),
                heroTag: null,
                onPressed: () {
                  _delete();
                },
                backgroundColor: Colors.red[900],
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  value: getPriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      debugPrint('User selected $valueSelectedByUser');
                      updatePriorityAsInt(valueSelectedByUser);
                    });
                  }),
            ),
            TextField(
              controller: titleController,
              maxLines: null,
              onChanged: (text) {
                note.title = titleController.text;
              },
              decoration: InputDecoration(
                labelText: 'title',
                labelStyle: TextStyle(color: Colors.red[900]),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[900]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[900]),
                ),
              ),
            ),
            TextField(
              controller: descriptionController,
              maxLines: null,
              onChanged: (text) {
                name = descriptionController.text;
              },
              decoration: InputDecoration(
                labelText: 'description',
                labelStyle: TextStyle(color: Colors.red[900]),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[900]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[900]),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                  child: TextHighlight(
                    text: _text,
                    words: _highlights,
                    textStyle: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: EdgeInsets.all(25.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: ElevatedButton(
            //           onPressed: () {
            //             _save();
            //           },
            //           child: Text('Save'),
            //         ),
            //       ),
            //       SizedBox(
            //         width: 10.0,
            //       ),
            //       Expanded(
            //         child: ElevatedButton(
            //           onPressed: () {
            //             _delete();
            //           },
            //           child: Text('Delete'),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Save data to database
  void _save() async {
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.title == '') {
      _showAlertDialog('Status', 'Please enter title');
      return;
    }
    moveToLastScreen();
    if (note.id != null) {
      // Case 1: Update operation
      note.description = name;
      result = await databaseHelper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      note.description = name;

      result = await databaseHelper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (_text != 'Press the button and start speaking') {
              name = _text;
              print('name ' + name);
            }

            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
