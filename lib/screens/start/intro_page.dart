import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../utils/logger.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  void onBtnClick() {
    logger.d('btn clicked');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('토마토마켓', style: TextStyle(fontSize: 30, color: Colors.red, fontWeight: FontWeight.bold)),
            ExtendedImage.asset('assets/imgs/carrot_intro.png'),
            Text('우리 동네 중고 직거래 토마토마켓', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('\'토마토마켓은 동네 직거래 마켓이에요.\n내 동네를 설정하고 시작해보세요.\'', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                    onPressed: onBtnClick,
                    child: Text('내 동네 설정하고 시작하기', style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(backgroundColor: Colors.lightBlueAccent)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}