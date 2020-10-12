import 'dart:async';

import 'package:ble_connect/UARTCommands/UARTCommands.dart';
import 'package:ble_connect/Views/PopUpDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:ble_connect/Globals/globals.dart' as globals;

class DeviceView extends StatefulWidget {
  @override
  _DeviceViewState createState() => new _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  BluetoothService serviceUART, serviceBattery;

  void findServices() {
    print("searching");
    for (BluetoothService service in globals.services) {
      serviceUART =
          service.uuid.toString().contains("6e4000") ? service : serviceUART;
      serviceBattery = service.uuid.toString().contains("0000180f")
          ? service
          : serviceBattery;
    }
    notify(serviceUART);
  }

  @override
  void initState() {
    findServices();
    const time = const Duration(seconds: 30);
    new Timer.periodic(time, (Timer t) => notify(serviceUART));

    super.initState();
  }

  ListView buildDeviceView(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      Container(
          height: 50,
          color: Colors.grey[900],
          child: Center(
              child: Text("UART-UUID: " + serviceUART.uuid.toString(),
                  style: TextStyle(color: Colors.white)))),
      Container(
          height: 50,
          color: Colors.grey[800],
          child: Center(
              child: Text("Battery-UUID: " + serviceBattery.uuid.toString(),
                  style: TextStyle(color: Colors.white)))),
      Container(
          height: 50,
          margin: new EdgeInsets.only(bottom: 20.0),
          color: Colors.grey[700],
          child: Center(
              child: Text("Wynik: " + globals.result,
                  style: TextStyle(color: Colors.white)))),
      Container(
        height: 50,
        child: RaisedButton(
            color: Colors.blue[400],
            child: Text('Get Time', style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              globals.result = await getCommand(serviceUART, "gt");
              setState(() {
                globals.result = globals.result;
              });
            }),
      ),
      Container(
        height: 50,
        child: RaisedButton(
            color: Colors.blue[300],
            child:
                Text('Get Records', style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              globals.result = await getCommand(serviceUART, "gr");
              setState(() {
                globals.result = globals.result;
              });
            }),
      ),
      Container(
        height: 50,
        child: RaisedButton(
            color: Colors.blue[200],
            child:
                Text('Get Record', style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              await generateDialog2(context, serviceUART);
              setState(() {
                globals.result = globals.result;
              });
            }),
      ),
      /*Container(
        height: 50,
        color: Colors.amber[600],
        child: RaisedButton(
            child: Text('Get Record 1', style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              globals.result = await getRecord(serviceUART, "1");
              setState(() {
                globals.result = globals.result;
              });
            }),
      ),*/
      Container(
        height: 50,
        child: RaisedButton(
            color: Colors.blue[100],
            child: Text('Get Configuration',
                style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              globals.result = await getCommand(serviceUART, "gc");
              setState(() {
                globals.result = globals.result;
              });
            }),
      ),
      Container(
        height: 50,
        child: RaisedButton(
            color: Colors.green[400],
            child:
                Text('Set Config', style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              generateConfDialog(context, serviceUART);
            }),
      ),
      Container(
        height: 50,
        child: RaisedButton(
            color: Colors.green[300],
            child: Text('Set Time', style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              generateDialog(context, serviceUART);
            }),
      ),
      Container(
        height: 50,
        child: RaisedButton(
            color: Colors.green[200],
            child:
                Text('Set Time Now', style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              setTime(serviceUART, DateTime.now().toString());
            }),
      ),
      Container(
        height: 50,
        child: RaisedButton(
            color: Colors.amber[300],
            child:
                Text('Flush memory', style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              setCommand(serviceUART, "cm");
            }),
      ),
      /*Container(
        height: 50,
        color: Colors.amber[600],
        child: RaisedButton(
            child: Text('Command', style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              generateDialog1(context, serviceUART);
            }),
      ),*/
      Container(
        height: 50,
        child: RaisedButton(
            color: Colors.amber[100],
            child: Text('Battery', style: TextStyle(color: Colors.grey[900])),
            onPressed: () async {
              var sub = serviceBattery.characteristics
                  .where((element) => element.properties.read)
                  .first
                  .value
                  .listen((value) {
                print(value);
                setState(() {
                  globals.result = value.toString();
                });
              });
              await serviceBattery.characteristics
                  .where((element) => element.properties.read)
                  .first
                  .read();
              sub.cancel();
              serviceBattery.characteristics
                  .where((element) => element.properties.read)
                  .first
                  .value
                  .listen((value) {
                print('value: $value');
                setState(() {
                  globals.result = value.toString();
                });
              });
            }),
      ),
      Container(
          height: 50,
          margin: new EdgeInsets.only(top: 20.0),
          child: RaisedButton(
              child: Text('Disconnect', style: TextStyle(color: Colors.white)),
              color: Colors.red[900],
              onPressed: () async {
                areYouSureAlert(context, "route");
                //print(_connectedDevice);
              }))
      /*Container(
          height: 50,
          color: Colors.amber[500],
          child: RaisedButton(
              child: Text('Notify', style: TextStyle(color: Colors.grey[900])),
              onPressed: () async {
                notify(serviceUART);
              }))*/
    ]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Device"),
        ),
        body: buildDeviceView(context),
      );
}
