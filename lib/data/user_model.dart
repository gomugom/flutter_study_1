import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserModel {
  late String userKey;
  late String phoneNum;
  late String address;
  late DateTime createTime;
  late GeoFirePoint geoFirePoint;
  DocumentReference? documentReference;

  UserModel({
    required this.userKey,
    required this.phoneNum,
    required this.address,
    required this.createTime,
    required this.geoFirePoint,
    this.documentReference});

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.documentReference) {
    phoneNum = json['phoneNum'];
    address = json['address'];
    createTime = (json['createTime'] == null) ? DateTime.now().toUtc() : (json['createTime'] as Timestamp).toDate();
    geoFirePoint = GeoFirePoint((json['geoFirePoint']['geopoint']).latitude, (json['geoFirePoint']['geopoint']).longitude);
  }

  Map<String, dynamic> toJson() { // insert firebase
    final map = <String, dynamic>{};
    map['phoneNum'] = phoneNum;
    map['address'] = address;
    map['createTime'] = createTime;
    map['geoFirePoint'] = geoFirePoint.data;
    map['documentReference'] = documentReference;
    return map;
  }

  UserModel.fromSnapShot(DocumentSnapshot<Map<String,dynamic>> snapshot) : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

}