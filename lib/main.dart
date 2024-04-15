import 'package:bookvachak/screens/audio_player.dart';
import 'package:bookvachak/screens/main_screen.dart';
import 'package:bookvachak/services/audio_handler.dart';
import 'package:bookvachak/services/service_locator.dart';
import 'package:bookvachak/widgets/Player/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late MyAudioHandler _adh;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _adh = await setupServiceLocator();
  runApp(
    const MyApp(),
  );
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
