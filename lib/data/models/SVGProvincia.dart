import 'package:flutter/material.dart';

class SVGProvincia {
  final String label;
  final Path path; // La forma irregular
  final String estilo;
  bool estaPoseida;
  Color colorPropietario;

  SVGProvincia({
    required this.label,
    required this.path,
    required this.estilo,
    this.estaPoseida = false,
    this.colorPropietario = Colors.grey,
  });
}
