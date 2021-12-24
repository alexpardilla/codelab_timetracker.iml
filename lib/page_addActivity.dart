import 'package:codelab_timetracker/requests.dart';
import 'package:flutter/material.dart';



class PageAddActivity extends StatefulWidget {
  late int id;
  PageAddActivity(this.id);

  @override
  _PageAddActivityState createState() => _PageAddActivityState();
}

class _PageAddActivityState extends State<PageAddActivity> {
  //late Tree.Tree tree;
  late int id;

  final _listaC = ['Project', 'Task'];
  String _vistaC = 'Project';

  final _keyForm = GlobalKey<FormState>(); // Our created key
  final _name = TextEditingController();


  @override
  void initState() {
    super.initState();
    id = widget.id;

    //tree = Tree.getTreeTask();
    // the root is a task and the children its intervals
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      Scaffold(
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
      ),
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
            Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text('Que vols crear?'),

                      ),
                    ),

                    DropdownButton(
                      items: _listaC.map((String a) {
                        return DropdownMenuItem(
                            value: a,
                            child: Text(a)
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() =>
                        {
                          _vistaC = newValue as String
                        });
                      },
                      hint: Text(_vistaC),
                    ),
                  ],)

            ),
            ElevatedButton(
              child: const Text('Add Activity'),
              onPressed: () => createActivity(_name.text, _vistaC ,id),
            )
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
