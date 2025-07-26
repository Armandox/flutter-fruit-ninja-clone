import 'package:flutter/material.dart';
import '../models/game_state.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _buttonController;
  late Animation<double> _titleAnimation;
  late Animation<double> _buttonAnimation;
  
  GameMode selectedMode = GameMode.classic;

  @override
  void initState() {
    super.initState();
    
    _titleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.elasticOut,
    ));
    
    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOutBack,
    ));
    
    _titleController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Titolo animato
              Expanded(
                flex: 2,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _titleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _titleAnimation.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '🍎 FRUIT NINJA 🍊',
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 10,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'CLONE',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w300,
                                color: Colors.orange[300],
                                letterSpacing: 8,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Menu principale
              Expanded(
                flex: 3,
                child: AnimatedBuilder(
                  animation: _buttonAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _buttonAnimation.value)),
                      child: Opacity(
                        opacity: _buttonAnimation.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Selezione modalità
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Modalità di Gioco',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildModeSelector(),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // Pulsanti
                            _buildMenuButton(
                              'INIZIA GIOCO',
                              Icons.play_arrow,
                              Colors.green,
                              () => _startGame(),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            _buildMenuButton(
                              'IMPOSTAZIONI',
                              Icons.settings,
                              Colors.blue,
                              () => _showSettings(),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            _buildMenuButton(
                              'CLASSIFICA',
                              Icons.leaderboard,
                              Colors.purple,
                              () => _showLeaderboard(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: GameMode.values.map((mode) {
        final isSelected = selectedMode == mode;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedMode = mode;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _getModeIcon(mode),
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 5),
                Text(
                  _getModeName(mode),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getModeIcon(GameMode mode) {
    switch (mode) {
      case GameMode.classic:
        return '⚔️';
      case GameMode.arcade:
        return '🔥';
      case GameMode.zen:
        return '🧘';
    }
  }

  String _getModeName(GameMode mode) {
    switch (mode) {
      case GameMode.classic:
        return 'Classico';
      case GameMode.arcade:
        return 'Arcade';
      case GameMode.zen:
        return 'Zen';
    }
  }

  Widget _buildMenuButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: 300,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 15),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
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

  void _startGame() {
    Navigator.pushNamed(context, '/game', arguments: selectedMode);
  }

  void _showSettings() {
    // TODO: Implementare schermata impostazioni
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Impostazioni - Funzionalità in sviluppo'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showLeaderboard() {
    // TODO: Implementare classifica
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Classifica - Funzionalità in sviluppo'),
        backgroundColor: Colors.purple,
      ),
    );
  }
} 