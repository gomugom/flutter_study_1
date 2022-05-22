import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_1/state/user_provider.dart';

import '../../utils/logger.dart';
import 'package:provider/provider.dart'; // context.read<T>() 를 사용하기 위해 import 필요

class IntroPage extends StatelessWidget {

  PageController pageController;

  IntroPage(this.pageController, {Key? key}) : super(key: key);

  void onBtnClick() async {
    logger.d('btn clicked');

    var result = await Dio().get('https://randomuser.me/api/');

    logger.d('result : ${result.toString()}');

    pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {

    logger.d('current State : ${context.read<UserProvider>()}');

    return LayoutBuilder(
      builder: (context, constraints) {

        Size size = MediaQuery.of(context).size;

        final imgSize = size.width - 32;
        final imgPosSize = size.width * 0.1;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('토마토마켓', style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).primaryColor)),
                SizedBox(
                  width: imgSize,
                  height: imgSize,
                  child: Stack(children : [ // 쌓아주는 widget
                    ExtendedImage.asset('assets/imgs/carrot_intro.png'),
                    Positioned( // 배치를 담당
                        left: imgSize * 0.45,
                        width: imgPosSize,
                        bottom: imgSize * 0.45,
                        height: imgPosSize,
                        child: ExtendedImage.asset('assets/imgs/carrot_intro_pos.png')
                    )
                  ]),
                ),
                Text('우리 동네 중고 직거래 토마토마켓', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text('\'토마토마켓은 동네 직거래 마켓이에요.\n내 동네를 설정하고 시작해보세요.\'', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                        onPressed: onBtnClick,
                        child: Text('내 동네 설정하고 시작하기', style: Theme.of(context).textTheme.button),
                        style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor)
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
