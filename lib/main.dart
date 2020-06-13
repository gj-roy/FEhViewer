import 'package:FEhViewer/pages/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'config/global.dart';
import 'route/Application.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      onGenerateRoute: Application.router.generator,
//      title: 'FEhViewer',
      home: SplashPage(),
    );
  }
}