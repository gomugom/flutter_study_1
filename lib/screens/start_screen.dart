import 'package:flutter/material.dart';
import 'package:flutter_study_1/screens/start/address_page.dart';
import 'package:flutter_study_1/screens/start/auth_page.dart';
import 'package:flutter_study_1/screens/start/intro_page.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {

  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController();

    return Scaffold(
      body: Provider<PageController>.value(
        // create: (BuildContext context) {  }, // create는 무조건 객체를 재생성해서 전달해줘야함 => 안그럴려면 value 를 써라
        value: controller,
        child: PageView(
            controller: controller,
            // physics: NeverScrollableScrollPhysics(),
            children: [
              IntroPage(),
              AddressPage(),
              AuthPage()
            ]
        ),
      )
    );
  }

}
