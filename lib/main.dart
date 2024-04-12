import 'package:bookvachak/screens/main_screen.dart';
import 'package:bookvachak/services/service_locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'BookVachak',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        primarySwatch: Colors.green,
        primaryColor: Colors.amber,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MainScreen(),
      },
      // home: const MyAppTwo(),
    );
  }
}
