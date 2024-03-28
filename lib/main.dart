import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/utils/routes/route_names.dart';
import 'package:rentmything/utils/routes/routes.dart';
import 'package:rentmything/view_model/auth_view_model.dart';
import 'package:rentmything/view_model/user_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_)=>AuthViewModel()),
        ChangeNotifierProvider(create: (_)=>UserViewModel()),

      ],child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      initialRoute: RoutesName.splash,
      onGenerateRoute: Routes.generateRoute,
    ),);
  }
}