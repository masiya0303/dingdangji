// lib/routes/index.dart
import 'package:flutter/material.dart';
//  实现的页面，取消注释即可使用
//import 'package:checky/pages/Main/index.dart';
import 'package:untitled/pages/Login/index.dart';

// 以下页面尚未实现，使用时请取消注释并确保对应文件存在
// import 'package:checky/pages/Cart/index.dart';
// import 'package:checky/pages/Category/index.dart';
// import 'package:checky/pages/Mine/index.dart';
import 'package:untitled/pages/Home/index.dart';

/// 返回应用的根组件
Widget getRootWidget() {
  return MaterialApp(
    title: 'Checky',
    initialRoute: '/',
    routes: getRootRoutes(),
    onUnknownRoute: (settings) => MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text('404 - 页面不存在')),
      ),
    ),
  );
}

/// 路由表配置
Map<String, Widget Function(BuildContext)> getRootRoutes() {
  return {
    '/': (context) => const HomePage(),      // 主页（已实现）
    '/login': (context) => const LoginPage(), // 登录页（已实现）

    // 以下路由对应的页面尚未实现，需要时取消注释
    // '/cart': (context) => const CartPage(),
    // '/category': (context) => const CategoryPage(),
    // '/mine': (context) => const MinePage(),
    // '/home': (context) => const HomePage(),
  };
}