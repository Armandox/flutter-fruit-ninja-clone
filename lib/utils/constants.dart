import 'package:flutter/material.dart';

class GameConstants {
  // Dimensioni schermo target 4K
  static const double targetWidth = 3840.0;
  static const double targetHeight = 2160.0;
  
  // Fisica del gioco
  static const double gravity = 1500.0;
  static const double fruitSpawnRate = 1.0;
  static const double bombSpawnRate = 0.1;
  
  // Dimensioni oggetti
  static const double fruitRadius = 40.0;
  static const double sliceRadius = 80.0;
  
  // Colori
  static const Color backgroundColor = Color(0xFF87CEEB);
  static const Color menuBackground = Color(0xFF1a1a2e);
  static const Color primaryColor = Colors.orange;
  
  // Animazioni
  static const Duration titleAnimationDuration = Duration(seconds: 2);
  static const Duration buttonAnimationDuration = Duration(milliseconds: 800);
  
  // Punti per tipo di frutto
  static const Map<String, int> fruitPoints = {
    'apple': 10,
    'orange': 15,
    'watermelon': 25,
    'strawberry': 20,
    'banana': 12,
    'pineapple': 30,
    'bomb': -50,
  };
  
  // Emoji frutti
  static const Map<String, String> fruitEmojis = {
    'apple': '🍎',
    'orange': '🍊',
    'watermelon': '🍉',
    'strawberry': '🍓',
    'banana': '🍌',
    'pineapple': '🍍',
    'bomb': '💣',
  };
  
  // Colori frutti
  static const Map<String, Color> fruitColors = {
    'apple': Colors.red,
    'orange': Colors.orange,
    'watermelon': Colors.green,
    'strawberry': Color(0xFFE57373),
    'banana': Colors.yellow,
    'pineapple': Color(0xFFF57F17),
    'bomb': Colors.black,
  };
} 