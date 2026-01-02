import 'package:flutter/material.dart';

/// Clase para mostrar un indicador de carga.
/// Utilizada en el stream de autenticación por si este espera respuesta
class mapLoading extends StatelessWidget {
  const mapLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
