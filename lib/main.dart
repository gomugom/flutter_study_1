import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_1/router/home_location.dart';
import 'package:flutter_study_1/screens/auth_screen.dart';
import 'package:flutter_study_1/screens/home_screen.dart';
import 'package:flutter_study_1/screens/splash_screen.dart';
import 'package:flutter_study_1/utils/logger.dart';

final routerDelegate = BeamerDelegate(
  guards: [ // 특정 조건(미로그인 등)일 경우 보여줄 page 지정
    BeamGuard(
        pathBlueprints: ['/'],
        check: (context, location) {
          return false;
        },
        showPage: BeamPage(child: AuthScreen())
        //beamToNamed: (origin, target) => '/auth'
    )
  ],
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [HomeLocation()],
  )
);

void main() { // dart 시작 지점
  runApp(MyPage()); // flutter 시작지점
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: Future.delayed(Duration(milliseconds: 2000), () => 100),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
                duration: Duration(milliseconds: 1000),
                child: loadingSplashToMain(snapshot));
      }
    );
  }

  StatelessWidget loadingSplashToMain(AsyncSnapshot<Object> snapshot) {
    if(snapshot.hasError) {
      logger.e('Error occur!!');
      return Text('Error Occur!!');
    } else if(snapshot.hasData) {
      return TomatoApp();
    } else {
      return SplashScreen();
    }
  }
}

class TomatoApp extends StatelessWidget {
  const TomatoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate
    );
  }
}

