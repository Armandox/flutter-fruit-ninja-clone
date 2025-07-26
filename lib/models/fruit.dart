import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

enum FruitType {
  apple,
  orange,
  watermelon,
  strawberry,
  banana,
  pineapple,
  bomb,
}

class Fruit {
  final FruitType type;
  Vector2 position;
  Vector2 velocity;
  Vector2 acceleration;
  double rotation;
  double rotationSpeed;
  double scale;
  bool isSliced;
  bool isDead;
  int points;
  double lifeTime;
  double maxLifeTime;

  Fruit({
    required this.type,
    required this.position,
    required this.velocity,
    this.acceleration = const Vector2(0, 0),
    this.rotation = 0,
    this.rotationSpeed = 0,
    this.scale = 1.0,
    this.isSliced = false,
    this.isDead = false,
    this.points = 0,
    this.lifeTime = 0,
    this.maxLifeTime = 5.0,
  });

  factory Fruit.random(double screenWidth, double screenHeight) {
    final random = Random();
    final types = FruitType.values.where((type) => type != FruitType.bomb).toList();
    final type = types[random.nextInt(types.length)];
    
    // Posizione iniziale sotto lo schermo
    final x = random.nextDouble() * screenWidth;
    final y = screenHeight + 100;
    
    // Velocità verso l'alto con componente orizzontale casuale
    final velocityX = (random.nextDouble() - 0.5) * 200;
    final velocityY = -800 - random.nextDouble() * 400;
    
    // Rotazione casuale
    final rotationSpeed = (random.nextDouble() - 0.5) * 10;
    
    // Punti basati sul tipo di frutto
    int points;
    switch (type) {
      case FruitType.apple:
        points = 10;
        break;
      case FruitType.orange:
        points = 15;
        break;
      case FruitType.watermelon:
        points = 25;
        break;
      case FruitType.strawberry:
        points = 20;
        break;
      case FruitType.banana:
        points = 12;
        break;
      case FruitType.pineapple:
        points = 30;
        break;
      default:
        points = 10;
    }

    return Fruit(
      type: type,
      position: Vector2(x, y),
      velocity: Vector2(velocityX, velocityY),
      rotationSpeed: rotationSpeed,
      points: points,
    );
  }

  factory Fruit.bomb(double screenWidth, double screenHeight) {
    final random = Random();
    final x = random.nextDouble() * screenWidth;
    final y = screenHeight + 100;
    final velocityX = (random.nextDouble() - 0.5) * 200;
    final velocityY = -600 - random.nextDouble() * 300;

    return Fruit(
      type: FruitType.bomb,
      position: Vector2(x, y),
      velocity: Vector2(velocityX, velocityY),
      rotationSpeed: (random.nextDouble() - 0.5) * 8,
      points: -50,
    );
  }

  void update(double deltaTime) {
    if (isDead) return;

    lifeTime += deltaTime;
    
    // Applica gravità
    acceleration.y = 1500;
    
    // Aggiorna velocità
    velocity += acceleration * deltaTime;
    
    // Aggiorna posizione
    position += velocity * deltaTime;
    
    // Aggiorna rotazione
    rotation += rotationSpeed * deltaTime;
    
    // Controlla se il frutto è morto (troppo tempo o fuori schermo)
    if (lifeTime > maxLifeTime || position.y > 3000) {
      isDead = true;
    }
  }

  void slice() {
    if (!isSliced && !isDead) {
      isSliced = true;
      // Aumenta la velocità quando tagliato
      velocity *= 1.5;
      // Cambia la direzione
      velocity.x += (Random().nextDouble() - 0.5) * 400;
    }
  }

  Color getColor() {
    switch (type) {
      case FruitType.apple:
        return Colors.red;
      case FruitType.orange:
        return Colors.orange;
      case FruitType.watermelon:
        return Colors.green;
      case FruitType.strawberry:
        return Colors.red[300]!;
      case FruitType.banana:
        return Colors.yellow;
      case FruitType.pineapple:
        return Colors.yellow[700]!;
      case FruitType.bomb:
        return Colors.black;
    }
  }

  String getEmoji() {
    switch (type) {
      case FruitType.apple:
        return '🍎';
      case FruitType.orange:
        return '🍊';
      case FruitType.watermelon:
        return '🍉';
      case FruitType.strawberry:
        return '🍓';
      case FruitType.banana:
        return '🍌';
      case FruitType.pineapple:
        return '🍍';
      case FruitType.bomb:
        return '💣';
    }
  }
} 