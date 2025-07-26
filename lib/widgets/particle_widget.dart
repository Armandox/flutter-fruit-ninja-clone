import 'package:flutter/material.dart';
import '../models/game_state.dart';

class ParticleWidget extends StatelessWidget {
  final Particle particle;

  const ParticleWidget({
    super.key,
    required this.particle,
  });

  @override
  Widget build(BuildContext context) {
    if (particle.isDead) return const SizedBox.shrink();

    return Positioned(
      left: particle.position.x - 5,
      top: particle.position.y - 5,
      child: Opacity(
        opacity: particle.getAlpha(),
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: particle.color,
            boxShadow: [
              BoxShadow(
                color: particle.color.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 