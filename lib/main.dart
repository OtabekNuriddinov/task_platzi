import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_platzi/screen/auth/provider/auth_provider.dart';
import 'package:task_platzi/screen/home/home_provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'screen/catalog/catalog_provider.dart';


void main() {
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()..fetchProducts()),
        ChangeNotifierProvider(create: (_) => CatalogProvider()..fetchAll()),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: AppRoute.router,
      ),
    );
  }
}