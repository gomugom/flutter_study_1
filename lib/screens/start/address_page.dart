import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_1/constraints/shared_pref_keys.dart';
import 'package:flutter_study_1/data/AddressCoordinateModel.dart';
import 'package:flutter_study_1/data/AddressModel.dart';
import 'package:flutter_study_1/screens/start/address_service.dart';
import 'package:flutter_study_1/utils/logger.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constraints/common_constraints.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _addressController = TextEditingController();

  AddressModel? _addressModel;

  int _page = 1;

  ScrollController _scrollController = ScrollController();

  bool isSearching = false;

  List<AddressCoordinateModel> addressCoordinateModel = [];

  @override
  void dispose() {
    _addressController.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() async {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        ++_page;
        logger.d('reScroll-DOWN!!!');
        _addressModel = await AddressService().searchAddressByStr(_addressController.text, _page);
        setState(() {});
      } else if(_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
        if(_page != 1) {
          --_page;
        }
        logger.d('reScroll-UP!!!');
        _addressModel = await AddressService().searchAddressByStr(_addressController.text, _page);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: COMMON_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _addressController,
            onFieldSubmitted: (inputTxt) async {

              addressCoordinateModel.clear();

              if(inputTxt != null) {
                _page = 1;
                _addressModel = await AddressService().searchAddressByStr(inputTxt, _page);
                setState(() {}); // _addressModel이 변한 것을 알려주기 위해
              }
            },
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
              prefixIcon: Icon(Icons.search),
              prefixIconConstraints: BoxConstraints(minWidth: 16, maxHeight: 16),
              hintText: '주소로 검색하세요.',
              hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
              )
            ),
          ),
          SizedBox(height: COMMON_SMALL_PADDING),
          TextButton.icon(onPressed: () async {

            _addressModel = null;
            _addressController.text = '';

            addressCoordinateModel.clear();

            setState(() {
              isSearching = true;
            });

            Location location = new Location();

            bool _serviceEnabled;
            PermissionStatus _permissionGranted;
            LocationData _locationData;

            _serviceEnabled = await location.serviceEnabled();
            if (!_serviceEnabled) {
              _serviceEnabled = await location.requestService();
              if (!_serviceEnabled) {
                return;
              }
            }

            _permissionGranted = await location.hasPermission();
            if (_permissionGranted == PermissionStatus.denied) {
              _permissionGranted = await location.requestPermission();
              if (_permissionGranted != PermissionStatus.granted) {
                return;
              }
            }

            _locationData = await location.getLocation();

            logger.d('find location : ${_locationData}');

            if(_locationData != null) {
              addressCoordinateModel.addAll(await AddressService().searchAddressByCoordinates(_locationData.longitude, _locationData.latitude));
            }

            setState(() {
              isSearching = false;
            });

          }, label: Text(isSearching ? '현재위치 찾는 중...' : '현재 위치 찾기', style: Theme.of(context).textTheme.button),
             style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
             icon: isSearching ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white)) : Icon(CupertinoIcons.compass, color: Colors.white),
          ),
          SizedBox(height: COMMON_SMALL_PADDING),
          if(_addressModel != null)
            Expanded(
              child: ListView.builder(controller: _scrollController,
                  itemBuilder: (context, index) {
                    if(_addressModel==null||_addressModel?.response==null||_addressModel?.response!.result==null||_addressModel?.response!.result!.items==null ||_addressModel?.response!.result!.items![index]==null){
                      return Container();
                    } else {
                      return ListTile(
                          onTap: () {
                            this.saveAddressAndGoNextPage(_addressModel?.response!.result!.items![index].address!.road??'', 2,
                                num.parse(_addressModel?.response!.result!.items![index].point!.y ?? '0'),
                                num.parse(_addressModel?.response!.result!.items![index].point!.x ?? '0')
                            );
                          },
                          title: Text(_addressModel?.response!.result!.items![index].address!.road??''),
                          subtitle: Text(_addressModel!.response!.result!.items![index].address!.parcel??'')
                      );
                    }
                  },
                  itemCount: (_addressModel==null || _addressModel!.response==null || _addressModel!.response!.result==null || _addressModel!.response!.result!.items==null) ? 0 : _addressModel!.response!.result!.items!.length),
            )

          else if(addressCoordinateModel.isNotEmpty)
            Expanded(
              child: ListView.builder(controller: _scrollController,
                  itemBuilder: (context, index) {
                    if(addressCoordinateModel[index] == null || addressCoordinateModel[index].result!.isEmpty){
                      return Container();
                    } else {
                      return ListTile(
                          onTap: () {
                            this.saveAddressAndGoNextPage(addressCoordinateModel[index].result![0].text??'', 2,
                                num.parse(addressCoordinateModel[index].input!.point!.y ?? '0'),
                                num.parse(addressCoordinateModel[index].input!.point!.x ?? '0')
                            );
                          },
                          title: Text(addressCoordinateModel[index].result![0].text??''),
                          subtitle: Text(addressCoordinateModel[index].result![0].zipcode??'')
                      );
                    }
                  },
                  itemCount: addressCoordinateModel.length),
            )
        ]
      ),
    );
  }

  void saveAddressAndGoNextPage(String address, int page, num lat, num lon) {
    this.saveAddress(address, lat, lon);
    context.read<PageController>().animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void saveAddress(String addr, num lat, num lon) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(SHARED_ADDRESS, addr);
    await prefs.setDouble(SHARED_LAT, lat.toDouble());
    await prefs.setDouble(SHARED_LON, lon.toDouble());
  }

}
