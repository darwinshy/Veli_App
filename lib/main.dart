import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:veli/model/profiledata.dart';
import 'package:veli/root.dart';
import 'package:veli/screens/cartscreen.dart';
import 'package:veli/screens/profile.dart';
import 'authentication/auth.dart';
import 'model/cart.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(
          create: (ctx) => ProfileData(),
        )
      ],
      child: new MaterialApp(
        home: new MyApp(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case CartScreen.routeName:
              return PageTransition(
                  child: CartScreen(), type: PageTransitionType.fade);
              break;
            case Profile.routeName:
              return PageTransition(
                  child: Profile(), type: PageTransitionType.fade);
              break;
            default:
              return null;
          }
        },
        debugShowCheckedModeBanner: false,
        routes: {
          // CartScreen.routeName: (ctx) => CartScreen(),
          RootPage.routeName: (ctx) => RootPage(Auth()),
          // Profile.routeName: (ctx) => Profile()
        },
      ),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: RootPage(Auth()),
      title: new Text(
        'Veli',
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
            fontFamily: "sam",
            color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      loadingText: Text(
        "made with love for",
        style: TextStyle(fontFamily: "QuickSand", color: Colors.black38),
      ),
      subtitle: Text(
        "NIT Silchar",
        style: TextStyle(fontFamily: "QuickSand", color: Colors.black38),
      ),
      photoSize: 100.0,
    );
  }
}
