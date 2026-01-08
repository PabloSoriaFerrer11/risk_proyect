import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

// --- ESTADOS DE CONFIGURACIÓN DEL MAPA ---

/// Cálculos de escala sean coherentes
final svgBaseSizeProvider = Provider<double>((ref) => 300.0);

// --- ESTADOS DEL JUEGO ( RISK ) ---

final currentPlayerProvider = StateProvider<int>((ref) => 1);

/// Ejemplo: Fase del turno (Refuerzo, Ataque, Movimiento)
enum GamePhase { reinforcement, attack, fortification }

final gamePhaseProvider = StateProvider<GamePhase>(
  (ref) => GamePhase.reinforcement,
);
