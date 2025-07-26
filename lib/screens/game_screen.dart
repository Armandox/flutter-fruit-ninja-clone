import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_state.dart';
import '../models/fruit.dart';
import '../widgets/fruit_widget.dart';
import '../widgets/slice_trail.dart';
import '../widgets/particle_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameState gameState;
  late Timer gameTimer;
  late AnimationController _pauseController;
  late Animation<double> _pauseAnimation;
  
  bool isSlicing = false;
  Offset? lastSlicePoint;

  @override
  void initState() {
    super.initState();
    
    gameState = GameState();
    
    _pauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pauseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pauseController,
      curve: Curves.easeInOut,
    ));
    
    // Avvia il timer del gioco
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        gameState.update(0.016); // ~60 FPS
      }
    });
    
    // Imposta le dimensioni dello schermo quando disponibili
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      gameState.setScreenSize(size.width, size.height);
    });
  }

  @override
  void dispose() {
    gameTimer.cancel();
    _pauseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameMode = ModalRoute.of(context)?.settings.arguments as GameMode? ?? GameMode.classic;
    gameState.setGameMode(gameMode);
    
    return Scaffold(
      body: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF87CEEB),
                Color(0xFF98FB98),
                Color(0xFFF0E68C),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Sfondo con nuvole
              _buildBackground(),
              
              // Frutti
              ...gameState.fruits.map((fruit) => FruitWidget(fruit: fruit)),
              
              // Particelle
              ...gameState.particles.map((particle) => ParticleWidget(particle: particle)),
              
              // Trail del taglio
              if (gameState.sliceTrail.isNotEmpty)
                SliceTrail(points: gameState.sliceTrail),
              
              // UI del gioco
              _buildGameUI(),
              
              // Schermata di pausa
              if (gameState.isPaused) _buildPauseOverlay(),
              
              // Schermata di game over
              if (gameState.isGameOver) _buildGameOverOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return CustomPaint(
      painter: BackgroundPainter(),
      size: Size.infinite,
    );
  }

  Widget _buildGameUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Barra superiore
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Punteggio
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '${gameState.score}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Combo
                if (gameState.combo > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'COMBO x${gameState.combo}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                
                // Vite
                Row(
                  children: List.generate(
                    gameState.lives > 0 ? gameState.lives : 0,
                    (index) => const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Barra inferiore
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pulsante pausa
                GestureDetector(
                  onTap: () {
                    gameState.togglePause();
                    if (gameState.isPaused) {
                      _pauseController.forward();
                    } else {
                      _pauseController.reverse();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                
                // Tempo di gioco
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    '${(gameState.gameTime).toInt()}s',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return AnimatedBuilder(
      animation: _pauseAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _pauseAnimation.value,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'PAUSA',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildMenuButton(
                      'RIPRENDI',
                      Icons.play_arrow,
                      Colors.green,
                      () {
                        gameState.togglePause();
                        _pauseController.reverse();
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildMenuButton(
                      'MENU PRINCIPALE',
                      Icons.home,
                      Colors.blue,
                      () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameOverOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Punteggio: ${gameState.score}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Combo Massimo: ${gameState.maxCombo}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              _buildMenuButton(
                'RIGIOCA',
                Icons.refresh,
                Colors.green,
                () {
                  gameState.startGame();
                },
              ),
              const SizedBox(height: 15),
              _buildMenuButton(
                'MENU PRINCIPALE',
                Icons.home,
                Colors.blue,
                () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (gameState.isPaused || gameState.isGameOver) return;
    
    isSlicing = true;
    lastSlicePoint = details.localPosition;
    gameState.sliceAt(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isSlicing || gameState.isPaused || gameState.isGameOver) return;
    
    final currentPoint = details.localPosition;
    if (lastSlicePoint != null) {
      // Interpola punti tra l'ultimo punto e quello corrente
      final distance = (currentPoint - lastSlicePoint!).distance;
      final steps = (distance / 20).ceil(); // Un punto ogni 20 pixel
      
      for (int i = 1; i <= steps; i++) {
        final t = i / steps;
        final interpolatedPoint = Offset.lerp(lastSlicePoint!, currentPoint, t)!;
        gameState.sliceAt(interpolatedPoint);
      }
    }
    
    lastSlicePoint = currentPoint;
  }

  void _onPanEnd(DragEndDetails details) {
    isSlicing = false;
    lastSlicePoint = null;
    
    // Pulisci il trail dopo un breve delay
    Future.delayed(const Duration(milliseconds: 100), () {
      gameState.clearSliceTrail();
    });
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    // Disegna nuvole semplici
    for (int i = 0; i < 5; i++) {
      final x = (i * 200) % size.width;
      final y = 100 + (i * 50) % 200;
      
      canvas.drawCircle(Offset(x, y), 30, paint);
      canvas.drawCircle(Offset(x + 40, y), 25, paint);
      canvas.drawCircle(Offset(x + 20, y - 20), 20, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 