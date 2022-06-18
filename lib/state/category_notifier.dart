import 'package:flutter/widgets.dart';

var categoryNitifier = CategoryNotifier();

class CategoryNotifier extends ChangeNotifier {

  String _selectedCategoryInEng = "none";

  String get currentCategoryInEng => _selectedCategoryInEng;
  String get currentCategoryInKor => categoryListEngToKorMap[_selectedCategoryInEng]!;

  void setCategoryWithEng(String selectCategory) {
    if(categoryListEngToKorMap.keys.contains(selectCategory)) {
      _selectedCategoryInEng = selectCategory;
      notifyListeners();
    }
  }

  void setCategoryWithKor(String selectCategory) {
    if(categoryListKorToEngMap.keys.contains(selectCategory)) {
      _selectedCategoryInEng = categoryListKorToEngMap[selectCategory]!;
      notifyListeners();
    }
  }
}

const categoryListEngToKorMap = {
  "none" : '선택',
  "furniture" : '가구',
  "electronics" : '전자기기',
  "kids" : '유아동',
  'sports' : '스포츠',
  'man' : '남성',
  'woman' : '여성',
  'makeup' : '메이크업'
};

const categoryListKorToEngMap = {
  '선택' : "none",
  '가구' : "furniture",
  '전자기기' : "electronics",
  '유아동' : "kids",
  '스포츠' : 'sports',
  '남성' : 'man',
  '여성' : 'woman',
  '메이크업' : 'makeup'
};