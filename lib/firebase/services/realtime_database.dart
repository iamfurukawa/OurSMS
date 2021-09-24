import 'package:oursms/crypto/MD5.dart';
import 'package:oursms/firebase/services/firebase.dart';
import 'package:oursms/sms/SMS_message.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabase extends Firebase {
  DatabaseReference _databaseReference;

  RealtimeDatabase({String phoneNumber}) {
    _databaseReference = FirebaseDatabase.instance.reference()
        .child(MD5.generateHash(phoneNumber.replaceAll("(", "").replaceAll(")", "").replaceAll("-", "")));
    createOrUpdate(SMSMessage(message: "", type: SMSMessageType.DISCONNECTED));
  }

  void createOrUpdate(SMSMessage message) {
    _databaseReference.update(message.toJson());
    print("message updated="+message.toJson().toString());
  }

  Future<SMSMessage> retrieve() async {
    var snapshot = await _databaseReference.once();
    return SMSMessage.fromJson(snapshot.value);
  }
}
