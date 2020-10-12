import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';

import 'package:ble_connect/Globals/globals.dart' as globals;

getCommand(BluetoothService serviceUART, String command) async {
  String temp;
  temp = "";

  await serviceUART.characteristics
      .where((element) => element.properties.write)
      .first
      .write(utf8.encode(command));

  serviceUART.characteristics
      .where((element) => element.properties.notify)
      .first
      .value
      .listen((value) {
    print(value);

    for (int i = 0; i < value.length; i++) {
      if (command == "gt") {
        if (i == 4 || i == 6) temp += "-";
        if (i == 8) temp += "\t";
        if (i == 10 || i == 12) temp += ":";
      }
      if (value[i] != 10) temp += String.fromCharCode(value[i]);
    }
  });

  return Future.delayed(Duration.zero, () async => temp);

  // return Future.delayed(Duration(milliseconds: 200), () => temp);
}

notify(BluetoothService serviceUART) async {
  if (globals.connectedDevice != null) {
    await serviceUART.characteristics
        .where((element) => element.properties.notify)
        .first
        .setNotifyValue(true);
  }
}

setTime(BluetoothService serviceUART, String time) async {
  String result = "st ";
  for (int i = 0; i < time.length; i++) {
    if (time[i] != '-' && time[i] != ' ' && time[i] != ':') {
      if (time[i] == '.') {
        break;
      }
      result += time[i];
    }
  }
  await serviceUART.characteristics
      .where((element) => element.properties.write)
      .first
      .write(utf8.encode(result));
}

setCommand(BluetoothService serviceUART, String command) async {
  await serviceUART.characteristics
      .where((element) => element.properties.write)
      .first
      .write(utf8.encode(command));
}

setConfig(BluetoothService serviceUART, String von, String voff, String vs,
    String vp) async {
  await serviceUART.characteristics
      .where((element) => element.properties.write)
      .first
      .write(utf8.encode("von $von"));
  await serviceUART.characteristics
      .where((element) => element.properties.write)
      .first
      .write(utf8.encode("voff $voff"));
  await serviceUART.characteristics
      .where((element) => element.properties.write)
      .first
      .write(utf8.encode("vs $vs"));
  await serviceUART.characteristics
      .where((element) => element.properties.write)
      .first
      .write(utf8.encode("vp $vp"));
}

getRecord(BluetoothService serviceUART, String record) async {
  String temp = "", temp2 = "";
  await serviceUART.characteristics
      .where((element) => element.properties.write)
      .first
      .write(utf8.encode("gm " + record));
  serviceUART.characteristics
      .where((element) => element.properties.notify)
      .first
      .value
      .listen((value) {
    print(value);

    for (int i = 0; i < value.length; i++) {
      if ((value[i] >= 48 && value[i] <= 57) ||
          (value[i] >= 97 && value[i] <= 102)) {
        temp2 += String.fromCharCode(value[i]);
      } else {
        if (temp2.length >= 1) {
          temp += int.parse(temp2, radix: 16).toString();
          temp += ' ';
          temp2 = "";
        }
      }
    }
  });
  return Future.delayed(Duration.zero, () async => temp);
}
