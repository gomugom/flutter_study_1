import 'package:flutter/material.dart';
import 'package:flutter_study_1/screens/start/address_page.dart';
import 'package:flutter_study_1/screens/start/auth_page.dart';
import 'package:flutter_study_1/screens/start/intro_page.dart';

class StartScreen extends StatelessWidget {

  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController();

    return Scaffold(
      body: PageView(
          controller: controller,
          // physics: NeverScrollableScrollPhysics(),
          children: [
            IntroPage(controller),
            AddressPage(),
            AuthPage()
          ]
      )
    );
  }

}
