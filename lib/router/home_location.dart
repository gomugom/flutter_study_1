// LOCATIONS
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

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