import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rentmything/utils/routes/route_names.dart';
import 'package:rentmything/utils/routes/routes.dart';
import 'package:rentmything/view/notificationView/notificationcontroller.dart';
import 'package:rentmything/view_model/auth_view_model.dart';
import 'package:rentmything/view_model/user_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_)=>AuthViewModel()),
        ChangeNotifierProvider(create: (_)=>UserViewModel()),

      ],child: MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Rent My Thing',
      theme: ThemeData(
      ),
      initialRoute: RoutesName.splash,
      onGenerateRoute: Routes.generateRoute,
    ),);
  }
}