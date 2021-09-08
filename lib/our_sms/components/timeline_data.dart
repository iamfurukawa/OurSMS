import 'package:flutter/material.dart';

class TrackingInfo {
  TrackingInfo({
    @required this.id,
    @required this.date,
    @required this.deliveryProcesses,
  });

  final int id;
  final DateTime date;
  List<TrackingProcess> deliveryProcesses;
}

class TrackingProcess {
  TrackingProcess(
    this.name, {
    this.messages,
  });

  TrackingProcess.complete()
      : this.name = 'Done',
        this.messages = [];

  TrackingProcess.error()
      : this.name = 'Error',
        this.messages = [];

  final String name;
  List<TrackingMessage> messages = [];

  bool get isCompleted => name == 'Done';

  bool get isError => name == 'Error';
}

class TrackingMessage {
  TrackingMessage(this.message);

  final String createdAt =
      DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString() + ":" + DateTime.now().second.toString();
  final String message;

  @override
  String toString() {
    return '$createdAt - $message';
  }
}
