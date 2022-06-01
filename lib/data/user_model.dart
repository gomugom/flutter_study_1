import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserModel {
  late String userKey;
  late String phoneNum;
  late String address;
  late num lat;
  late num lot;
  late DateTime createTime;
  late GeoFirePoint geoFirePoint;
  late DocumentReference documentReference;

  UserModel({
    required this.userKey,
    required this.phoneNum,
    required this.address,
    required this.lat,
    required this.lot,
    required this.createTime,
    required this.geoFirePoint,
    required this.documentReference,});

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.documentReference) {
    phoneNum = json['phoneNum'];
    address = json['address'];
    lat = json['lat'];
    lot = json['lot'];
    createTime = (json['createTime'] == null) ? DateTime.now().toUtc() : (json['createTime'] as Timestamp).toDate();
    geoFirePoint = GeoFirePoint((json['geoFirePoint']['geopoint']).latitude, (json['geoFirePoint']['geopoint']).longitude);
  }

  Map<String, dynamic> toJson() { // insert firebase
    final map = <String, dynamic>{};
    map['phoneNum'] = phoneNum;
    map['address'] = address;
    map['lat'] = lat;
    map['lot'] = lot;
    map['createTime'] = createTime;
    map['geoFirePoint'] = geoFirePoint.data;
    map['documentReference'] = documentReference;
    return map;
  }
}