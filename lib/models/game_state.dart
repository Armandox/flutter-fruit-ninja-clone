import 'dart:math';
import 'package:flutter/material.dart';
import 'fruit.dart';

enum GameMode {
  classic,
  arcade,
  zen,
}

class GameState extends ChangeNotifier {
  List<Fruit> fruits = [];
  List<Offset> sliceTrail = [];
  int score = 0;
  int lives = 3;
  int combo = 0;
  int maxCombo = 0;
  double gameTime = 0;
  bool isGameOver = false;
  bool isPaused = false;
  GameMode gameMode = GameMode.classic;
  
  // Configurazioni per diversi modi di gioco
  double fruitSpawnRate = 1.0; // secondi
  double bombSpawnRate = 0.1; // probabilità
  double lastFruitSpawn = 0;
  
  // Dimensioni dello schermo
  double screenWidth = 3840;
  double screenHeight = 2160;
  
  // Effetti particellari
  List<Particle> particles = [];
  
  void setScreenSize(double width, double height) {
    screenWidth = width;
    screenHeight = height;
  }
  
  void setGameMode(GameMode mode) {
    gameMode = mode;
    switch (mode) {
      case GameMode.classic:
        lives = 3;
        fruitSpawnRate = 1.0;
        bombSpawnRate = 0.1;
        break;
      case GameMode.arcade:
        lives = 1;
        fruitSpawnRate = 0.8;
        bombSpawnRate = 0.15;
        break;
      case GameMode.zen:
        lives = -1; // infinite
        fruitSpawnRate = 1.2;
        bombSpawnRate = 0.0; // no bombs
        break;
    }
  }
  
  void startGame() {
    fruits.clear();
    sliceTrail.clear();
    particles.clear();
    score = 0;
    lives = 3;
    combo = 0;
    maxCombo = 0;
    gameTime = 0;
    isGameOver = false;
    isPaused = false;
    lastFruitSpawn = 0;
    setGameMode(gameMode);
    notifyListeners();
  }
  
  void update(double deltaTime) {
    if (isGameOver || isPaused) return;
    
    gameTime += deltaTime;
    
    // Spawn frutti
    if (gameTime - lastFruitSpawn > fruitSpawnRate) {
      spawnFruit();
      lastFruitSpawn = gameTime;
      
      // Aumenta la difficoltà nel tempo
      if (gameMode == GameMode.arcade) {
        fruitSpawnRate = max(0.3, 1.0 - (gameTime / 60.0) * 0.7);
      }
    }
    
    // Aggiorna frutti
    for (int i = fruits.length - 1; i >= 0; i--) {
      final fruit = fruits[i];
      fruit.update(deltaTime);
      
      // Rimuovi frutti morti
      if (fruit.isDead) {
        if (!fruit.isSliced && fruit.type != FruitType.bomb) {
          // Frutto non tagliato = perdita vita
          if (lives > 0) lives--;
          if (lives <= 0) {
            gameOver();
            return;
          }
        }
        fruits.removeAt(i);
      }
    }
    
    // Aggiorna particelle
    for (int i = particles.length - 1; i >= 0; i--) {
      final particle = particles[i];
      particle.update(deltaTime);
      if (particle.isDead) {
        particles.removeAt(i);
      }
    }
    
    // Pulisci trail del taglio
    if (sliceTrail.length > 20) {
      sliceTrail.removeAt(0);
    }
    
    notifyListeners();
  }
  
  void spawnFruit() {
    final random = Random();
    
    // Decidi se spawnare una bomba
    if (random.nextDouble() < bombSpawnRate) {
      fruits.add(Fruit.bomb(screenWidth, screenHeight));
    } else {
      fruits.add(Fruit.random(screenWidth, screenHeight));
    }
  }
  
  void sliceAt(Offset position) {
    sliceTrail.add(position);
    
    // Controlla collisioni con i frutti
    bool hitSomething = false;
    for (final fruit in fruits) {
      if (!fruit.isSliced && !fruit.isDead) {
        final distance = (fruit.position - Vector2(position.dx, position.dy)).length;
        if (distance < 80) { // Raggio di collisione
          fruit.slice();
          hitSomething = true;
          
          if (fruit.type == FruitType.bomb) {
            // Bomba tagliata = perdita vita
            if (lives > 0) lives--;
            if (lives <= 0) {
              gameOver();
              return;
            }
            combo = 0;
            createExplosion(fruit.position);
          } else {
            // Frutto tagliato = punti
            score += fruit.points * (combo + 1);
            combo++;
            if (combo > maxCombo) maxCombo = combo;
            createSliceEffect(fruit.position, fruit.getColor());
          }
        }
      }
    }
    
    if (!hitSomething) {
      combo = 0;
    }
    
    notifyListeners();
  }
  
  void createSliceEffect(Vector2 position, Color color) {
    for (int i = 0; i < 10; i++) {
      particles.add(Particle(
        position: position.clone(),
        velocity: Vector2(
          (Random().nextDouble() - 0.5) * 300,
          (Random().nextDouble() - 0.5) * 300,
        ),
        color: color,
        lifeTime: 0.5,
      ));
    }
  }
  
  void createExplosion(Vector2 position) {
    for (int i = 0; i < 20; i++) {
      particles.add(Particle(
        position: position.clone(),
        velocity: Vector2(
          (Random().nextDouble() - 0.5) * 500,
          (Random().nextDouble() - 0.5) * 500,
        ),
        color: Colors.orange,
        lifeTime: 1.0,
      ));
    }
  }
  
  void gameOver() {
    isGameOver = true;
    notifyListeners();
  }
  
  void togglePause() {
    isPaused = !isPaused;
    notifyListeners();
  }
  
  void clearSliceTrail() {
    sliceTrail.clear();
    notifyListeners();
  }
}

class Particle {
  Vector2 position;
  Vector2 velocity;
  Color color;
  double lifeTime;
  double maxLifeTime;
  bool isDead = false;
  
  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.lifeTime,
  }) : maxLifeTime = lifeTime;
  
  void update(double deltaTime) {
    if (isDead) return;
    
    lifeTime -= deltaTime;
    if (lifeTime <= 0) {
      isDead = true;
      return;
    }
    
    // Applica gravità
    velocity.y += 500 * deltaTime;
    
    // Aggiorna posizione
    position += velocity * deltaTime;
  }
  
  double getAlpha() {
    return lifeTime / maxLifeTime;
  }
} 