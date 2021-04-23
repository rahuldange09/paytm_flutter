import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:paytm_flutter/paytm_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _response = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String response;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final result = await Paytm().startTransaction(
          mid: "Paytm1232141",
          orderId: "Order1234",
          amount: "324",
          txnToken: "rar123asf");
      response = result.toString();
    } on PlatformException {
      response = 'Failed to get result.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _response = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Paytm Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_response\n'),
        ),
      ),
    );
  }
}
