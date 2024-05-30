// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:PerfumeDream/models/model_product_provider.dart';
import 'package:PerfumeDream/screens/screen_detail.dart';
import 'package:PerfumeDream/screens/screen_find_id.dart';
import 'package:PerfumeDream/screens/screen_find_password.dart';
import 'package:PerfumeDream/screens/screen_search.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'models/model_auth.dart';
import 'models/model_cart.dart';
import 'models/model_query.dart';
import 'models/user_model/user_model.dart';
import 'screens/screen_splash.dart';
import 'screens/screen_index.dart';
import 'screens/screen_login.dart';
import 'screens/screen_register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeSharedPreferences();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => QueryProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: GetMaterialApp(
      //MaterialApp(
        theme: ThemeData(
            fontFamily: "Compagnon"
        ),
        title: 'Flutter Shopping mall',
        routes: {
          '/index': (context) => IndexScreen(),
          '/login': (context) => LoginScreen(),
          '/splash': (context) => SplashScreen(),
          '/register': (context) => RegisterScreen(),
          '/detail': (context) => DetailScreen(),
          '/search': (context) => SearchScreen(),
          '/id_recovery' : (context) => IdRecoveryScreen(),
          '/password_recovery' : (context) => IdRecoveryScreen(),
        },
        initialRoute: '/splash',
      ),
    );
  }
}