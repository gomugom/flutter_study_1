import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_1/state/category_notifier.dart';
import 'package:provider/provider.dart';

class InputCategoryScreen extends StatefulWidget {
  const InputCategoryScreen({Key? key}) : super(key: key);

  @override
  State<InputCategoryScreen> createState() => _InputCategoryScreenState();
}

class _InputCategoryScreenState extends State<InputCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리 선택', style: Theme.of(context).textTheme.headline6),
      ),
      body: ListView.separated(itemBuilder: (context, index) {
        return ListTile(
          title: Text(
              categoryListEngToKorMap.values.elementAt(index),
              style: TextStyle(
                color: context.read<CategoryNotifier>().currentCategoryInKor==categoryListEngToKorMap.values.elementAt(index) ? Theme.of(context).primaryColor : Colors.black87
              ),
          ),
          onTap: () {
            context.read<CategoryNotifier>().setCategoryWithEng(categoryListKorToEngMap.values.elementAt(index));
            context.beamBack();
          },
        );
      }, separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey,
          height: 1,
          thickness: 1
        );
      }, itemCount: categoryListEngToKorMap.keys.length),
    );
  }
}

