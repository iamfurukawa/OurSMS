import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oursms/firebase/services/realtime_database.dart';
import 'package:oursms/our_sms/components/timeline_data.dart';
import 'package:oursms/sms/SMS_message.dart';
import 'package:sms_maintained/sms.dart';

class OurSMSService with ChangeNotifier {
  String _cellphoneNumber = "";

  String _cellphoneNumberFilter = "";

  String _textFilter = "";

  bool _running = false;

  var _receiver = SmsReceiver();

  StreamSubscription<SmsMessage> _listener;

  RealtimeDatabase _realtime;

  var _state = SMSMessage();

  TrackingInfo _trackingInfo = TrackingInfo(
    date: DateTime.now(),
    deliveryProcesses: [],
  );

  get isRunning => this._running;

  get getCellphoneNumber => this._cellphoneNumber;

  set setCellphoneNumber(String cellphoneNumber) {
    this._cellphoneNumber = cellphoneNumber;
    this.stopRunning();
    notifyListeners();
  }

  get getCellphoneNumberFilter => this._cellphoneNumberFilter;

  set setCellphoneNumberFilter(String cellphoneNumberFilter) {
    this._cellphoneNumberFilter = cellphoneNumberFilter;
    this.stopRunning();
    notifyListeners();
  }

  get getTextFilter => this._textFilter;

  set setTextFilter(String textFilter) {
    this._textFilter = textFilter;
    this.stopRunning();
    notifyListeners();
  }

  get status => this._trackingInfo;

  SmsMessage _validateSMSMessage(SmsMessage smsMessage) {
    bool valid = true;
    if (_textFilter != null && _textFilter.isNotEmpty)
      valid = smsMessage.body.contains(_textFilter.trim()) ? true : false;

    if(!valid) _logSMS(TrackingMessage("Blocking by contain text filter"));

    if (valid == true && _cellphoneNumberFilter != null && _cellphoneNumberFilter.isNotEmpty)
      valid = smsMessage.address == _cellphoneNumberFilter.trim() ? true : false;

    if(!valid) _logSMS(TrackingMessage("Blocking by phone number filter"));

    return valid ? smsMessage : null;
  }

  void _handleOnSMSReceived(SmsMessage smsMessage) {
    _logSMS(TrackingMessage("Received SMS from " + smsMessage.address + " with message: " + smsMessage.body));
    var smsValid = _validateSMSMessage(smsMessage);

    if (smsValid == null) {
      _logSMS(TrackingMessage("SMS isn't sent to SDK"));
      return;
    }

    var smsMessageRealtime = SMSMessage(
      message: smsValid.body.replaceAll("\“", "").replaceAll("\”", ""),
      type: SMSMessageType.FLUTTER_HAS_CHANGED,
    );
    _realtime.createOrUpdate(smsMessageRealtime);
    _logSMS(TrackingMessage("SMS sent to SDK"));
  }

  void _startListener() {
    if (_listener != null) {
      print("Listener already started");
      return;
    }

    _listener = _receiver.onSmsReceived.listen(_handleOnSMSReceived);
    _logStart(TrackingMessage("Listener SMS started"));
  }

  void _stopListener() {
    if (_listener == null) {
      print("Listener not started yet");
      return;
    }

    _listener.cancel();
    _listener = null;
    _logEnd(TrackingMessage("Listener SMS stopped"));
  }

  void startRunning() async {
    if (_running == true) {
      print("App is already running");
      return;
    }

    _logReset();
    _logStart(TrackingMessage("Prepare listeners"));
    _running = true;
    _realtime = RealtimeDatabase(phoneNumber: getCellphoneNumber);
    _startListener();
    _realtimeListener();
    notifyListeners();
    _logStart(TrackingMessage("Listening..."));
  }

  void stopRunning() {
    if (_running == false) {
      print("App is not started yet");
      return;
    }

    _logEnd(TrackingMessage("Stop listen..."));
    _running = false;
    _realtime = null;
    _stopListener();
    notifyListeners();
    _logEnd(TrackingMessage("Stopped listen"));
    _trackingInfo.deliveryProcesses.add(TrackingProcess.complete());
  }

  Future<void> _realtimeListener() async {
    _logStart(TrackingMessage("Listener Realtime started"));
    Timer.periodic(Duration(seconds: 6), (timer) {
      if (!_running) {
        timer.cancel();
        _logEnd(TrackingMessage("Listener Realtime stopped"));
      }

      if (_realtime != null)
        _realtime.retrieve().then((value) {
          if(value == null) return;
          print("Scanning status from realtime");
          var actualState = SMSMessage.fromJson(value.toJson());
          if (_state.type != actualState.type) {
            print("actualState="+actualState.toString());
            _logSDK(TrackingMessage(_logMapper(actualState.type)));
            _state = actualState;
          }
        }).catchError((err) {
          print("Error on reading realtime database: " + err.toString());
        });
    });
  }

  String _logMapper(SMSMessageType type) {
    switch (type) {
      case SMSMessageType.STARTING:
        return "App is starting";
      case SMSMessageType.WAITING_FOR_UPDATES:
        return "App is waiting for updates";
      case SMSMessageType.FLUTTER_NOT_LISTENING:
        return "Cellphone isn't listening SMS";
      case SMSMessageType.FLUTTER_LISTENING:
        return "Cellphone is listening SMS";
      case SMSMessageType.FLUTTER_HAS_CHANGED:
        return "Cellphone send message to app";
      case SMSMessageType.DISCONNECTED:
        return "App was disconnected";
    }
    return "Error on read message";
  }

  void _logExists(String processName) {
    var idx = _trackingInfo.deliveryProcesses.indexWhere((process) => process.name == processName);
    if (idx == -1) _trackingInfo.deliveryProcesses.add(TrackingProcess(processName, messages: []));
  }

  void _logStart(TrackingMessage trackingMessage) {
    _logExists("Starting");
    _trackingInfo.deliveryProcesses[0].messages.add(trackingMessage);
    notifyListeners();
  }

  void _logSMS(TrackingMessage trackingMessage) {
    _logExists("Starting");
    _logExists("SMS");
    _trackingInfo.deliveryProcesses[1].messages.add(trackingMessage);
    notifyListeners();
  }

  void _logSDK(TrackingMessage trackingMessage) {
    _logExists("Starting");
    _logExists("SMS");
    _logExists("SDK");
    _trackingInfo.deliveryProcesses[2].messages.add(trackingMessage);
    notifyListeners();
  }

  void _logEnd(TrackingMessage trackingMessage) {
    _logExists("Starting");
    _logExists("SMS");
    _logExists("SDK");
    _logExists("Stopping");
    _trackingInfo.deliveryProcesses[3].messages.add(trackingMessage);
    notifyListeners();
  }

  void _logReset() {
    _trackingInfo = TrackingInfo(
      date: DateTime.now(),
      deliveryProcesses: [],
    );
    notifyListeners();
  }
}
