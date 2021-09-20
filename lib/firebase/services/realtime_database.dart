import 'package:firebase_database/firebase_database.dart';
import 'package:oursms/crypto/MD5.dart';
import 'package:oursms/firebase/services/firebase.dart';
import 'package:oursms/sms/SMS_message.dart';

class RealtimeDatabase extends Firebase {
  DatabaseReference _databaseReference;

  RealtimeDatabase({String phoneNumber}) {
    _databaseReference = FirebaseDatabase.instance.reference()
        .child(MD5.generateHash(phoneNumber.replaceAll("(", "").replaceAll(")", "").replaceAll("-", "")));
  }

  void createOrUpdate(SMSMessage message) {
    _databaseReference.update(message.toJson());
  }

  Future<SMSMessage> retrieve() async {
    var snapshot = await _databaseReference.once();
    if(snapshot.value == null)
      return Future<SMSMessage>.value(null);
    return SMSMessage.fromJson(snapshot.value);
  }
}
