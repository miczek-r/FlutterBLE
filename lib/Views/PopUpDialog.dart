import 'package:ble_connect/UARTCommands/UARTCommands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:ble_connect/Globals/globals.dart' as globals;

generateDialog(BuildContext context, BluetoothService serviceUART) {
  final _writeController = MaskedTextController(mask: '0000-00-00 00:00:00');
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set Time(yyyy-mm-dd hh:mm:ss)"),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                    controller: _writeController,
                    decoration:
                        InputDecoration(hintText: 'yyyy-mm-dd hh:mm:ss')),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Send"),
              onPressed: () {
                setTime(serviceUART, _writeController.value.text);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

/*generateDialog1(BuildContext context, BluetoothService serviceUART) {
  final _writeController = TextEditingController();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Command"),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _writeController,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Send"),
              onPressed: () {
                setCommand(serviceUART, _writeController.value.text);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}*/

generateDialog2(BuildContext context, BluetoothService serviceUART) {
  final _writeController = MaskedTextController(mask: '0000');

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Get Record"),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _writeController,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Send"),
              onPressed: () async {
                globals.result =
                    await getRecord(serviceUART, (_writeController.value.text));

                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

generateConfDialog(BuildContext context, BluetoothService serviceUART) {
  final _von = MaskedTextController(mask: '00.00');
  final _voff = MaskedTextController(mask: '00.00');
  final _vs = MaskedTextController(mask: '000');
  final _vp = MaskedTextController(mask: '00');
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("von -> voff -> vs -> vp"),
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                        controller: _von,
                        decoration: InputDecoration(
                            hintText: 'Poziom zadziałania rejestratora')),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                        controller: _voff,
                        decoration: InputDecoration(
                            hintText: 'Poziom wyłączenia rejestratora')),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                        controller: _vs,
                        decoration: InputDecoration(hintText: 'Czas analizy')),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                        controller: _vp,
                        decoration: InputDecoration(hintText: 'Liczba prób')),
                  ),
                ],
              ),
            ],
          ),

          /*content: Column(
            children: <Widget>[
              Flexible(
                child: TextField(
                    controller: _von,
                    decoration: InputDecoration(
                        hintText: 'Poziom zadziałania rejestratora')),
              ),
              Flexible(
                child: TextField(
                    controller: _voff,
                    decoration: InputDecoration(
                        hintText: 'Poziom wyłączenia rejestratora')),
              ),
              Flexible(
                child: TextField(
                    controller: _vs,
                    decoration: InputDecoration(hintText: 'Czas analizy')),
              ),
              Flexible(
                child: TextField(
                    controller: _vp,
                    decoration: InputDecoration(hintText: 'Liczba prób')),
              ),
            ],
          ),*/
          actions: <Widget>[
            FlatButton(
              child: Text("Send"),
              onPressed: () {
                setConfig(serviceUART, _von.value.text, _voff.value.text,
                    _vs.value.text, _vp.value.text);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

areYouSureAlert(BuildContext context, String route) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Disconnecting.'),
        content: Text("Are You Sure Want To Disconnect ?"),
        actions: <Widget>[
          FlatButton(
            child: Text("YES"),
            onPressed: () {
              //Put your code here which you want to execute on Yes button click.

              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          FlatButton(
            child: Text("NO"),
            onPressed: () {
              //Put your code here which you want to execute on No button click.
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
