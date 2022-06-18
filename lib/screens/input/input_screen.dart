import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:flutter_study_1/constraints/common_constraints.dart';
import 'package:flutter_study_1/screens/input/multi_image_select.dart';
import 'package:flutter_study_1/state/category_notifier.dart';
import 'package:provider/provider.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  var _suggestPriceSelected = false;
  var _divider = Divider(
    color: Colors.grey[350],
    thickness: 1,
    height: 1,
    indent: COMMON_PADDING,
    endIndent: COMMON_PADDING,
  );
  var _border = UnderlineInputBorder(
      borderSide: BorderSide(
          color: Colors.transparent
      )
  );
  TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              context.beamBack(); // 뒤로가기(Home 으로 이동)
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor
            ),
            child: Text('닫기', style: Theme.of(context).textTheme.bodyText2),
          ),
          title: Center(child: Text('중고거래 글쓰기', style: Theme.of(context).textTheme.headline6)),
          actions: [
            TextButton(
              onPressed: () {

              },
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor
              ),
              child: Text('완료', style: Theme.of(context).textTheme.bodyText2),
            )
          ],
          elevation: 10,
      ),
      body: ListView(
        children: [
          MultiImageSelect(),
          _divider,
          TextFormField(
            decoration: InputDecoration(
              hintText: '글 제목',
              contentPadding: EdgeInsets.symmetric(horizontal: COMMON_PADDING),
              border: _border,
              enabledBorder: _border,
              focusedBorder: _border
            ),
          ),
          _divider,
          ListTile(
            onTap: () {
              context.beamToNamed("/input/categorySelect");
            },
            dense: true,
            title: Text(
                    context.watch<CategoryNotifier>().currentCategoryInKor),
            trailing: Icon(Icons.navigate_next),
          ),
          _divider,
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: COMMON_PADDING),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    onChanged: (value) {
                      if(value == '0') {
                        _priceController.clear();
                      }
                      setState(() {

                      });
                    },
                    inputFormatters: [
                      MoneyInputFormatter(mantissaLength: 0)
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: COMMON_SMALL_PADDING),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)
                      ),
                      prefixIcon: Icon(CupertinoIcons.money_dollar,
                                        color: (_priceController.text.isEmpty ? Colors.grey[350] : Colors.black87)),
                      prefixIconConstraints: BoxConstraints(
                        maxWidth: 20,maxHeight: 20
                      ),
                      hintText: '얼마에 사시겠어요?',
                    ),
                  ),
                ),
              ),
              TextButton.icon(
                  onPressed: () {
                      setState(() {
                        _suggestPriceSelected = !_suggestPriceSelected;
                      });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    primary: Colors.black45
                  ),
                  icon: Icon(
                      _suggestPriceSelected ? Icons.check_circle : Icons.check_circle_outline,
                      color: _suggestPriceSelected ? Theme.of(context).primaryColor : Colors.black54
                  ),
                  label: Text(
                      '가격제안 받기',
                      style: TextStyle(
                        color: _suggestPriceSelected ? Theme.of(context).primaryColor : Colors.black54
                      )
                  )
              )
            ],
          ),
          _divider,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: COMMON_PADDING),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: '올릴 게시글 내용을 입력해주세요.',
                border: _border,
                focusedBorder: _border,
                enabledBorder: _border
              ),
            ),
          )
        ]
      ),
    );
  }
}
