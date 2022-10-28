import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:working_orders_app_tablet/providers/auth.dart';
import 'package:working_orders_app_tablet/screens/visited_places_detail_screen.dart';
import 'package:working_orders_app_tablet/screens/visited_places_list.screen.dart';
import 'package:working_orders_app_tablet/screens/working_orders_locations.dart';
import 'package:working_orders_app_tablet/screens/working_order_detailview.dart';
import './providers/working_order.dart';
import 'package:working_orders_app_tablet/providers/great_places.dart';
import 'package:working_orders_app_tablet/screens/login_screen.dart';
import 'package:working_orders_app_tablet/screens/splash_screen.dart';
import 'package:working_orders_app_tablet/screens/users_screen.dart';
import 'package:working_orders_app_tablet/screens/user_password_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String tokens;
  final String sessionAuth;
  final String userId;
  final String companyName;
  final List<WorkingOrder> item = [];
  final List<GreatPlaces> placesItems = [];

  MyApp(
      {Key? key,
      sessionId,
      this.tokens = '',
      this.sessionAuth = '',
      this.userId = '',
      this.companyName = ''})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(tokens),
          ),
          //ChangeNotifierProvider(create: (context) => SecondLoginScreen(),),
          ChangeNotifierProvider(create: ((context) {
            UsersScreen();
          })),
          ChangeNotifierProvider(
            create: (context) {
              VisitedPlacesListScreen();
            },
          )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme(
                  brightness: Brightness.light,
                  primary: Colors.lightBlue,
                  onPrimary: Colors.white,
                  secondary: Colors.redAccent,
                  onSecondary: Colors.white,
                  error: Colors.red,
                  onError: Colors.white30,
                  background: Colors.blueGrey,
                  onBackground: Colors.white,
                  surface: Colors.lightBlueAccent,
                  onSurface: Colors.lightGreen),
            ),
            home: auth.isAuth
                ? UserPasswordScreen() //: LoginScreen(),

                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: ((context, authSnapshot) =>
                        authSnapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : LoginScreen())),
            routes: {
              WorkingOrdersDetailView.routeName: ((context) =>
                  WorkingOrdersDetailView()),
              UsersScreen.routeName: ((context) => UsersScreen()),
              UserPasswordScreen.routeName: ((context) => UserPasswordScreen()),
              WorkingOrdersLocationsScreen.routeName: ((context) =>
                  WorkingOrdersLocationsScreen()),
              VisitedPlacesListScreen.routeName: ((context) =>
                  VisitedPlacesListScreen()),
              VisitedPlacesDetailScreen.routeName: ((context) =>
                  VisitedPlacesDetailScreen()),
            },
          ),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyShop',
          style: TextStyle(fontSize: 40),
        ),
      ),
      body: Center(
        child: Text('Let\'s work!'),
      ),
    );
  }
}
