import 'package:dio/dio.dart';
import 'package:flutter_study_1/constraints/keys.dart';
import 'package:flutter_study_1/data/AddressModel.dart';
import 'package:flutter_study_1/utils/logger.dart';

import '../../data/AddressCoordinateModel.dart';

class AddressService {
  void dioTest() async {
    var result = Dio().get('https://randomuser.me/api/').catchError((e){
      logger.d(e.toString());
    });
    logger.d(result);
  }

  Future<AddressModel> searchAddressByStr(String txt, int page) async {
    final Map<String, dynamic> param = {
      'key' : VWORLD_KEY,
      'request' : 'search',
      'size' : 10,
      'page' : page,
      'query' : txt,
      'type' : 'ADDRESS',
      'category' : 'ROAD'
    };

    final response = await Dio().get('http://api.vworld.kr/req/search', queryParameters: param).catchError((e){
      logger.e(e.message);
    });

    AddressModel addressModel = AddressModel.fromJson(response.data);
    logger.d(addressModel);

    return addressModel;
; }

  Future<List<AddressCoordinateModel>> searchAddressByCoordinates(double? log, double? lat) async {

    List<Map<String,dynamic>> params = <Map<String, dynamic>>[];

    params.add({
      'key' : VWORLD_KEY,
      'service' : 'address',
      'request' : 'getAddress',
      'type' : 'PARCEL',
      'point' : '$log,$lat'
    });

    params.add({
      'key' : VWORLD_KEY,
      'service' : 'address',
      'request' : 'getAddress',
      'type' : 'PARCEL',
      'point' : '${log! + 0.01},$lat'
    });

    params.add({
      'key' : VWORLD_KEY,
      'service' : 'address',
      'request' : 'getAddress',
      'type' : 'PARCEL',
      'point' : '${log - 0.01},$lat'
    });

    params.add({
      'key' : VWORLD_KEY,
      'service' : 'address',
      'request' : 'getAddress',
      'type' : 'PARCEL',
      'point' : '${log},${lat! - 0.01}'
    });

    params.add({
      'key' : VWORLD_KEY,
      'service' : 'address',
      'request' : 'getAddress',
      'type' : 'PARCEL',
      'point' : '${log},${lat + 0.01}'
    });

    List<AddressCoordinateModel> addresses = [];

    for(Map<String,dynamic> param in params) {
      final response = await Dio().get('http://api.vworld.kr/req/address', queryParameters: param).catchError((e) {
        logger.e(e.message);
      });

      AddressCoordinateModel addressModel = AddressCoordinateModel.fromJson(response.data['response']);

      logger.d(addressModel);

      if(response.data['response'] != null && response.data['response']['status'] == 'OK') {
        addresses.add(addressModel);
      }

    }

    return addresses;

  }

}