import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_study_1/data/data_keys.dart';
import 'package:flutter_study_1/utils/logger.dart';

class UserService {

  // singletone 패턴 생성 방법
  static final UserService _userService = UserService._internal();
  factory UserService() => _userService;
  UserService._internal();

  void createNewUser(Map<String, dynamic> json, String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    if(!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }

  void testWriteFireStore() {
    FirebaseFirestore.instance.collection('test_collection').add({
      'test1' : 'test1Val',
      'testName1' : 'test1NameVal'
    });
  }

  void testReadFireStore() async {
    FirebaseFirestore.instance.collection('test_collection').doc('1Cx0PPFFmqQnNbMssJNq')
        .get().then((value) => logger.d(value.data()));
  }
}