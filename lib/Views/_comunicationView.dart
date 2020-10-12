import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:ble_connect/Globals/globals.dart' as globals;

class MyHomePage extends StatefulWidget {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  String loadingId = "";

  @override
  void initState() {
    isLoading = false;
    super.initState();

    scanForDevices();
  }

  scanForDevices() {
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device) && device.name.contains("PSAR")) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();

    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              (isLoading && loadingId == device.id.toString())
                  ? CircularProgressIndicator()
                  : FlatButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                          loadingId = device.id.toString();
                        });
                        Future.delayed(const Duration(seconds: 20), () {
                          setState(() {
                            isLoading = false;
                            if (globals.connectedDevice == null)
                              device.disconnect();
                          });
                        });
                        widget.flutterBlue.stopScan();

                        try {
                          await device.connect();
                        } catch (e) {
                          if (e.code != 'already_connected') {
                            throw e;
                          }
                        } finally {
                          globals.services = await device.discoverServices();
                        }
                        setState(() {
                          globals.connectedDevice = device;
                        });
                      },
                    ),
            ],
          ),
        ),
      );
    }

    //
    containers.add(
      Container(
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[Text("test"), Text("test")],
              ),
            ),
            FlatButton(
              color: Theme.of(context).accentColor,
              child: Text(
                'Test',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Future.delayed(Duration.zero, () async {
                  await Navigator.pushNamed(context, '/test');
                });
              },
            ),
          ],
        ),
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  bool deviceView = false;
  ListView _buildView() {
    if (globals.connectedDevice == null) {
      return _buildListViewOfDevices();
    } else {
      if (!deviceView) {
        deviceView = true;
        Future.delayed(Duration.zero, () async {
          await Navigator.pushNamed(context, '/device').then((value) {
            setState(() {
              isLoading = false;
              globals.connectedDevice.disconnect();
              globals.connectedDevice = null;
              globals.result = "";
              deviceView = false;
            });
          });

          scanForDevices();
        });
      }
    }
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          appBar: AppBar(
            title: Text("Device List"),
          ),
          body: _buildView(),
        ));
  }
}
