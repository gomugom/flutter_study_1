import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_1/router/home_location.dart';
import 'package:flutter_study_1/screens/start_screen.dart';
import 'package:flutter_study_1/screens/splash_screen.dart';
import 'package:flutter_study_1/state/user_provider.dart';
import 'package:flutter_study_1/utils/logger.dart';
import 'package:provider/provider.dart';

final routerDelegate = BeamerDelegate(
  guards: [ // 특정 조건(미로그인 등)일 경우 보여줄 page 지정
    BeamGuard(
        pathBlueprints: ['/'],
        check: (context, location) {
          return true;
          //return context.watch<UserProvider>().user != null;  // read() => notifier()를 안받음, watch() => notifier를 부를 때마다 호출됨
        },
        showPage: BeamPage(child: StartScreen())
        //beamToNamed: (origin, target) => '/auth'
    )
  ],
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [HomeLocation()],
  )
);

void main() async { // dart 시작 지점
  Provider.debugCheckInvalidValueType = null;
  runApp(MyPage()); // flutter 시작지점
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  // Firebase core initialization 필요함 => stateless일경우 상태변화시 앱을 계속 재로딩할 수 있음으로 stateFul widget으로 해야함
  Future<FirebaseApp> defaultApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: defaultApp,
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
    } else if(snapshot.connectionState == ConnectionState.done) {
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
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) { return UserProvider(); },
      child: MaterialApp.router(
          routeInformationParser: BeamerParser(),
          routerDelegate: routerDelegate,
          theme: ThemeData(
            fontFamily: 'jua',
            primarySwatch: Colors.red,
            textTheme: TextTheme(
              headline3: TextStyle(
                fontFamily: 'jua'
              ),
              button: TextStyle(
                color: Colors.white
              ),
              subtitle1: TextStyle(fontSize: 16, color : Colors.black87, fontFamily: 'jua'),
              subtitle2: TextStyle(fontSize: 13, color : Colors.grey, fontFamily: 'jua')
            ),
            hintColor: Colors.grey[400],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'jua'
              ),
              actionsIconTheme: IconThemeData(color: Colors.black87)
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(48, 48),
                textStyle: TextStyle(fontFamily: 'jua'),
                primary: Colors.white
              )
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.black87,
              unselectedItemColor: Colors.black45
            )
          )
      ),
    );
  }
}

