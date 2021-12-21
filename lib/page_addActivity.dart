import 'package:codelab_timetracker/page_activities.dart';
import 'package:codelab_timetracker/tree.dart';
import 'package:flutter/material.dart';


class PageAddActivity extends StatefulWidget {

  @override
  _PageAddActivityState createState() => _PageAddActivityState();
}

class _PageAddActivityState extends State<PageAddActivity> {
  //late Tree.Tree tree;
  final _keyForm = GlobalKey<FormState>(); // Our created key
  final _name = TextEditingController();
  final _class = TextEditingController();
  final _initialDate = TextEditingController();
  final _finalDate = TextEditingController();
  final _duration = TextEditingController();

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: Text("FORM"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.home),
                onPressed: () {
                  while(Navigator.of(context).canPop()) {
                    print("pop");
                    Navigator.of(context).pop();
                  }
                }),
          ],
        ),
        body: _buildRow(),
      );
    }


  Widget _buildRow() {
    return Form(
      key: _keyForm,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('Add task or project'),
            ),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(hintText: 'Insert name of task/project'),
            ),
            TextFormField(
              controller: _class,
              decoration: InputDecoration(hintText: 'Insert name of task/project'),
            ),
            TextFormField(
              controller: _initialDate,
              obscureText: true,
              decoration: InputDecoration(hintText: 'The password to log in.'),
            ),
            TextFormField(
              controller: _finalDate,
              decoration: InputDecoration(hintText: 'E-mail to use for log in.'),
            ),
          ],
        ),
      ),
    );
  }

  void _addActivity() {

  }

  @override
  void dispose() {
    // "The framework calls this method when this State object will never build again"
    // therefore when going up
    super.dispose();
  }
}
