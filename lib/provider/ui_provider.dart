import 'package:flutter/material.dart';
import 'package:risk_proyect/data/models/SVGProvincia.dart';
import 'package:riverpod/legacy.dart';

final mousePositionProvider = StateProvider<Offset?>((ref) => null);

// --- ESTADOS DE INTERACCIÓN ---

/// Almacena el ID o el objeto de la provincia que está seleccionada actualmente
final selectedProvinciaProvider = StateProvider<SVGProvincia?>((ref) => null);

/// Almacena la provincia que tiene el ratón encima (opcional, para tooltips)
final hoveredProvinciaProvider = StateProvider<SVGProvincia?>((ref) => null);
