import 'package:flutter/material.dart';
import 'package:codelab_timetracker/page_intervals.dart';
import 'page_report.dart';
import 'package:codelab_timetracker/tree.dart' hide getTree;
// the old getTree()
import 'package:codelab_timetracker/requests.dart';
// has the new getTree() that sends an http request to the server
import 'dart:async';
import 'package:codelab_timetracker/page_addActivity.dart';

class PageActivities extends StatefulWidget {
  final int id;

  PageActivities(this.id);

  //const PageActivities({Key? key}) : super(key: key);

  @override
  _PageActivitiesState createState() => _PageActivitiesState();
}

class _PageActivitiesState extends State<PageActivities> {
  //late Tree tree;
  late int id;
  late int depth = 5;
  late Future<Tree> futureTree;
  late Timer _timer;
  static const int periodRefresh = 2;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    futureTree = getTree(id);
    _activateTimer();
    //tree = getTree();
  }


  // future with listview
  // https://medium.com/nonstopio/flutter-future-builder-with-list-view-builder-d7212314e8c9
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tree>(
      future: futureTree,
      // this makes the tree of children, when available, go into snapshot.data
      builder: (context, snapshot) {
        // anonymous function
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(id == 0 ? "Time Tracker" : snapshot.data!.root.name),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.home),
                    onPressed: () {
                      while(Navigator.of(context).canPop()) {
                        print("pop");
                        Navigator.of(context).pop();
                      }

                    }),
                //TODO other actions
              ],
            ),
            body:
            ListView.separated(
              // it's like ListView.builder() but better because it includes a separator between items
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.root.children.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildRow(snapshot.data!.root.children[index], index),
              separatorBuilder: (BuildContext context, int index) =>
              const Divider(),

            ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: Container(
                height: 150.0,
                color: Colors.blue[700],
                alignment: Alignment.center,
                child: Text('Nombre: ${snapshot.data!.root.name}\n'
                    'Fecha final: ${snapshot.data!.root.initialDate != null ?
                  snapshot.data!.root.initialDate.toString().split('.').first : "No hay tiempo"}\n'
                    'Fecha inicial: ${snapshot.data!.root.finalDate != null ?
                  snapshot.data!.root.finalDate.toString().split('.').first : "No hay tiempo"}\n'
                    'Duración total: ${snapshot.data!.root.duration}\n'
                    'Id: ${snapshot.data!.root.id}\n',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white)),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageAddActivity(id)),
                  );
                }

            ),

          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a progress indicator
        return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  Widget _buildRow(Activity activity, int index) {
    String strDuration = Duration(seconds: activity.duration).toString().split('.').first;
    // split by '.' and taking first element of resulting list removes the microseconds part

    if (activity is Project) {
      return ListTile(
        title: Text('${activity.name} \nDuración: $strDuration'),
        subtitle: const Text('Proyecto'),
        onTap: () => _navigateDownActivities(activity.id),
      );
    } else if (activity is Task) {
      Task task = activity;
      // at the moment is the same, maybe changes in the future
      return ListTile(
        title: Text('${task.name} \nDuración: $strDuration'),
        subtitle: Text('Tarea \n${task.active ? "Activo" :  "No activo"} '),
        onTap: () => _navigateDownIntervals(task.id),
        trailing: IconButton(
        icon: (activity).active ? const Icon(Icons.pause_circle_outline) : const Icon(Icons.play_circle_fill_outlined),
        onPressed: () {
          if ((task).active) {
            stop(task.id);
            _refresh(); //to show immediately that task has started
          } else {
            start(task.id);
            _refresh(); //to show immediately that task has stopped
          }
        }),
      );
    } else {
      throw(Exception("La actividad no es ni una tarea ni un proyecto"));
      // this solves the problem of return Widget is not nullable because an
      // Exception is also a Widget?
    }

  }

  void _navigateDownActivities(int childId) {
    _timer.cancel();
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageActivities(childId),
    )).then((var value) {
      _activateTimer();
      _refresh();
    });
  }

  void _navigateDownIntervals(int childId) {
    _timer.cancel();
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageIntervals(childId),
    )).then((var value) {
      _activateTimer();
      _refresh();
    });
  }

  void _refresh() async {
    futureTree = getTree(id);
    setState(() {});
  }

  void _activateTimer() {
    _timer = Timer.periodic(const Duration(seconds: periodRefresh), (Timer t) {
      futureTree = getTree(id);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // "The framework calls this method when this State object will never build again"
    // therefore when going up
    _timer.cancel();
    super.dispose();
  }
}
