
import 'dart:ui';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/utils/routes/route_names.dart';
import 'package:rentmything/utils/routes/routes.dart';
import 'package:rentmything/view/notificationView/notificationcontroller.dart';
import 'package:rentmything/view_model/auth_view_model.dart';
import 'package:rentmything/view_model/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SharedPreferences.getInstance().then((prefs){
    runApp( MyApp(prefs: prefs,));
  });
}


class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({required this.prefs,super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_)=>AuthViewModel()),
        ChangeNotifierProvider(create: (_)=>UserViewModel()),
        ChangeNotifierProvider(create: (_)=>ThemeProvider(prefs: prefs)),

      ],child: Consumer<ThemeProvider>(
        builder: (_,themeProvider, __) {
          return MaterialApp(
          navigatorKey: MyApp.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Rent My Thing',
          theme:themeProvider.isDarkMode ? ThemeData.dark(
          ).copyWith(
            textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Poppins',
            )
          ) : ThemeData.light(
            useMaterial3: true,
          ).copyWith(
              textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'Poppins',
              )
          ),
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
              );
        }
      ),);
  }
}

class ThemeProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  late bool _isDarkMode;

  ThemeProvider({required SharedPreferences prefs}) {
    _prefs = prefs;
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
  }

  bool get isDarkMode => _isDarkMode;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  ColorScheme lightColorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.color1,
      onPrimary: AppColors.color1,
      secondary: AppColors.color2,
      onSecondary: AppColors.color2,
      error: Colors.red,
      onError: Colors.red,
      background: Colors.white,
      onBackground: Colors.white,
      surface: Colors.white,
      onSurface: Colors.white);
}