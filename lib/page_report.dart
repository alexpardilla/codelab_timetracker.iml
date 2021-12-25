import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PageReport extends StatefulWidget {
  const PageReport({Key? key}) : super(key: key);

  @override
  _PageReportState createState() => _PageReportState();
}

class _PageReportState extends State<PageReport> {
  var _listaR = ['Last week', 'This week', 'Yesterday', 'Today', 'Other'];
  String _vistaR = 'Last week';

  DateFormat formatter = DateFormat('yyyy-mm-dd');
  int ForT = 0;
  DateTime _oldDTimeF = DateTime.now();
  DateTime _oldDTimeT = DateTime.now();
  DateTime _dateTimeF = DateTime.now();
  DateTime _dateTimeT = DateTime.now();
  DateTime today = DateTime.now();

  var _listaC = ['Brief', 'Detalled', 'Statistic'];
  String _vistaC = 'Brief';

  var _listaF = ['Web page', 'PDF', 'Text'];
  String _vistaF = 'Web page';

  @override
  void initState() {
    // TODO: implement initState
    DateTime mondayThisWeek = DateTime(
        today.year, today.month, today.day - today.weekday + 1);

    if (_vistaR == 'Today') {
      _dateTimeF = DateTime.now();
      _dateTimeT = DateTime.now();
    }
    if (_vistaR == 'Yesterday') {
      _dateTimeF = today.subtract(Duration(days: 1));
      _dateTimeT = today.subtract(Duration(days: 1));
    }
    if (_vistaR == 'This week') {
      _dateTimeF =
          DateTime(today.year, today.month, today.day - today.weekday + 1);
      _dateTimeT = DateTime.now();
    }
    if (_vistaR == 'Last week') {
      _dateTimeT = mondayThisWeek.subtract(new Duration(days: 1));
      _dateTimeF = mondayThisWeek.subtract(new Duration(days: 7));
    }
    if (_vistaR == 'Other') {
      _pickFromDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Report'),
        ),
        body: Container(
          margin: new EdgeInsets.only(left: 50.0, right: 70.0),
          width: 400,
          child: Column(
            children: <Widget>[


              //PARTE DEL PERIOD DONE!
              Expanded(
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                            child: Text('Period',
                              //textAlign: TextAlign.center,

                            ),)
                      ),

                      DropdownButton(
                        items: _listaR.map((String a) {
                          return DropdownMenuItem(
                            value: a,
                            child: Text(a),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() =>
                          {
                            _vistaR = newValue as String,
                          });
                          initState();
                        },
                        hint: Text(_vistaR),
                      ),
                    ],)

              ),

              //PARTE DEL FROM, FALTA QUITAR HORA!
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(

                          child: Text('From'),

                        ),
                      ),

                      Expanded(
                        child: Container(
                          alignment: FractionalOffset(0.2, 0.6),
                          child: Text('${_dateTimeF.year}-${_dateTimeF.month}-${_dateTimeF.day}'),
                        ),),

                      IconButton(icon: Icon(Icons.calendar_today, color: Colors.blue),
                        onPressed: () {
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2025)
                          ).then((date) {

                            setState(() {
                              _oldDTimeF = _dateTimeF;
                              ForT = 1;
                              _dateTimeF = date as DateTime;
                              _vistaR = 'Other';
                            });
                            initState();
                          });
                        },
                      )
                    ],)

              ),

              //PARTE DEL TO, FALTA QUITAR HORA!
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(

                          child: Text('To'),

                        ),
                      ),

                      Expanded(
                        child: Container(

                          child: Text('${_dateTimeT.year}-${_dateTimeT.month}-${_dateTimeT.day}'),
                        ),),

                      IconButton(icon: Icon(Icons.calendar_today, color: Colors.blue),
                        onPressed: () {
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2025)
                          ).then((date) {
                            setState(() {
                              _oldDTimeT = _dateTimeT;
                              ForT = 2;
                              _dateTimeT = date as DateTime;
                              _vistaR = 'Other';
                            });
                            initState();
                          });
                        },
                      )


                    ],)

              ),

              //PARTE DEL CONTENT, DONE!
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(

                          child: Text('Content'),

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

              //PARTE DEL FORMAT, DONE!
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(

                          child: Text('Format'),

                        ),
                      ),

                      DropdownButton(
                        items: _listaF.map((String a) {
                          return DropdownMenuItem(
                              value: a,
                              child: Text(a)
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() =>
                          {
                            _vistaF = newValue as String
                          });
                        },
                        hint: Text(_vistaF),
                      ),
                    ],)

              ),

              //PARTE DEL GENERATE, DONE PERO DIFERENTE
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 25),
                  ),
                  onPressed: () {},
                  child: const Text('Generate'),),

              ),


            ],
          ),)
    );
  }

  void _pickFromDate() async {
    /*DateTime? newStart = await showDatePicker(
      context: context,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 5),
      initialDate: today,
    );*/
    DateTime newStart = _dateTimeF;
    DateTime end = _dateTimeT; // the present To date
    if (end.difference(newStart) >= Duration(days: 0)) {
      setState(() {
        _vistaR = 'Other'; // to redraw the screen
      });
    } else {
      _showAlertDates();
      if(ForT == 1){
        _dateTimeF = _oldDTimeF;
      }
      if(ForT == 2){
        _dateTimeT = _oldDTimeT;
      }

    }
  }

  Future<void> _showAlertDates() {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Range dates'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('The From date is after the To date.'),
                Text(' '),
                Text('Please, select a new date.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ACCEPT', textScaleFactor: 1.5,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}