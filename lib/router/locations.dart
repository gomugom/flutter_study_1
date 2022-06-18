// LOCATIONS
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_1/screens/input/input_category_screen.dart';
import 'package:flutter_study_1/screens/input/input_screen.dart';
import 'package:flutter_study_1/state/category_notifier.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';

class HomeLocation extends BeamLocation<BeamState> {

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {

    final pages = [
      BeamPage(
        key: ValueKey('home'),
        title: 'Home',
        child: HomeScreen(),
      )
    ];

    return pages;

  }

  @override
  // TODO: implement pathBlueprints
  List get pathBlueprints => ['/'];

}

class InputLocation extends BeamLocation<BeamState> {

  @override
  Widget builder(BuildContext context, Widget navigator) {
    return ChangeNotifierProvider.value( // 객체가 이미 존재하는 것을 가져다 쓸 땐 .value로 등록
        value: categoryNitifier,
        child: super.builder(context, navigator));
  }
  
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {

    List<BeamPage> pages = [
      ...HomeLocation().buildPages(context, state),
      if(state.pathBlueprintSegments.contains('input'))
        BeamPage(
          key: ValueKey('input'),
          title: 'input',
          child: InputScreen(),
        ),
      if(state.pathBlueprintSegments.contains("categorySelect"))
        BeamPage(
          key: ValueKey('categorySelect'),
          title: 'categorySelect',
          child: InputCategoryScreen(),
        )
    ];

    return pages;

  }

  @override
  // TODO: implement pathBlueprints
  List get pathBlueprints => ['/input', '/input/categorySelect'];


}