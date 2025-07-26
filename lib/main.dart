import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/game_screen.dart';
import 'screens/menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Imposta l'orientamento del dispositivo a landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Nasconde la barra di stato
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  
  runApp(const FruitNinjaApp());
}

class FruitNinjaApp extends StatelessWidget {
  const FruitNinjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Ninja Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'GameFont',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MenuScreen(),
      routes: {
        '/menu': (context) => const MenuScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
} 