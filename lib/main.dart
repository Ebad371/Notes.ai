import 'package:flutter/material.dart';
import 'package:note_keeper_app/screens/img_to_text.dart';
import 'package:note_keeper_app/screens/new_screen.dart';
import 'package:note_keeper_app/screens/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper App',
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            // actions: <Widget>[
            //   IconButton(
            //     icon: Icon(
            //       Icons.help,
            //       color: Colors.white,
            //     ),
            //     onPressed: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) {
            //         return SecondRoute();
            //       }));
            //     },
            //   )
            // ],
            title: Text(
              'Notes.ai',
              style: TextStyle(fontSize: 30.0),
            ),
            bottom: TabBar(
              tabs: [Text('Notes'), Text('Img2Txt')],
              indicatorColor: Colors.red[900],
            ),
            backgroundColor: Colors.black87,
          ),
          body: TabBarView(
            children: [NoteList(), Img2Text()],
          ),
        ),
      ),
    );
  }
}
