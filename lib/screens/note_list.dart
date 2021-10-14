import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:note_keeper_app/models/note.dart';
import 'package:note_keeper_app/screens/new_screen.dart';
import 'package:note_keeper_app/screens/note_detail.dart';
import 'package:note_keeper_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      body: getNoteListView(),
      backgroundColor: Colors.black87,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              debugPrint('FAB clicked');
              navigateToDetail(Note('', '', 2), 'Add Note');
            },
            tooltip: 'Add Note',
            child: Icon(Icons.add),
            backgroundColor: Colors.red[900],
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            child: Icon(
              Icons.help,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SecondRoute();
              }));
            },
            heroTag: null,
            backgroundColor: Colors.red[900],
          ),
        ],
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          height: 80,
          child: Center(
            child: Card(
              color: Colors.grey[400],
              child: ListTile(
                leading: Container(
                    width: 10,
                    height: 50,
                    color: getPriorityColor(this.noteList[position].priority),
                    child: Container()),
                title: Text(this.noteList[position].title),
                subtitle: Text(this.noteList[position].date),
                trailing: GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    _delete(context, noteList[position]);
                  },
                ),
                onTap: () async {
                  bool result = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return NoteDetail(this.noteList[position], 'Edit Note');
                  }));

                  if (result == true) {
                    updateListView();
                  }
                  debugPrint('listtile tapped');
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red[900];
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right, color: Colors.red[900]);
        break;

      default:
        return Icon(
          Icons.keyboard_arrow_right,
          color: Colors.red[900],
        );
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
