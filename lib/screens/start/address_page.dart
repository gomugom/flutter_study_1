import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constraints/common_constraints.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: COMMON_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
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
          TextButton.icon(onPressed: () {

          }, label: Text('현재 위치 찾기', style: Theme.of(context).textTheme.button),
             style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
             icon: Icon(CupertinoIcons.compass, color: Colors.white),
          ),
          SizedBox(height: COMMON_SMALL_PADDING),
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              return Text('Text : $index');
            }, itemCount: 30),
          )
        ]
      ),
    );
  }
}
