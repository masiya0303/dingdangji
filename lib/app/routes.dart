import 'package:flutter/material.dart';
import '../../presentation/pages/home/home_page.dart';

class RouteNames {
  static const String home = '/';
}

class AppRoutes {
  static Map<String, WidgetBuilder> get routes {
    return {
      RouteNames.home: (context) => const HomePage(),
    };
  }

  static const String initialRoute = RouteNames.home;
}