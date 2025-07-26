import 'package:flutter/material.dart';
import '../models/fruit.dart';

class FruitWidget extends StatelessWidget {
  final Fruit fruit;

  const FruitWidget({
    super.key,
    required this.fruit,
  });

  @override
  Widget build(BuildContext context) {
    if (fruit.isDead) return const SizedBox.shrink();

    return Positioned(
      left: fruit.position.x - 40,
      top: fruit.position.y - 40,
      child: Transform.rotate(
        angle: fruit.rotation,
        child: Transform.scale(
          scale: fruit.scale,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fruit.getColor(),
              boxShadow: [
                BoxShadow(
                  color: fruit.getColor().withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                fruit.getEmoji(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 