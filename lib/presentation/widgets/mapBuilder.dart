import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:risk_proyect/data/models/SVGProvincia.dart';
import 'package:risk_proyect/provider/loadmap_provider.dart';
import 'package:risk_proyect/provider/ui_provider.dart';

// StreamBuilder o FutureBuilder
class mapBuilder extends ConsumerWidget {
  final String mapId;
  final double mapWidth;
  final double mapHeight;

  const mapBuilder({
    super.key,
    required this.mapId,
    required this.mapWidth,
    required this.mapHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mousePos = ref.watch(mousePositionProvider);

    final loadMap = ref.watch(mapaDataProvider(mapId));

    return loadMap.when(
      data: (data) {
        return GestureDetector(
          onTapDown: (details) {
            final tapPos = details.localPosition;
            double svgWidth = 300;
            double scaleX = mapWidth / svgWidth;
            double scaleY = mapHeight / svgWidth;
            double scale = scaleX < scaleY ? scaleX : scaleY;

            final adjustedTapPos = Offset(tapPos.dx / scale, tapPos.dy / scale);

            try {
              final provinciaClicada = data.firstWhere(
                (provincia) => provincia.path.contains(adjustedTapPos),
              );

              // Aquí puedes llamar a un notifier para abrir un diálogo,
              // cambiar de pantalla o actualizar un estado de "provincia seleccionada"
              ref.read(selectedProvinciaProvider.notifier).state =
                  provinciaClicada;
            } catch (e) {
              print("Clic fuera de una provincia");
            }
          },
          child: CustomPaint(
            painter: dibujarProvncias(data, mousePos),
            size: Size(mapWidth.toDouble(), mapHeight.toDouble()),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),

      error: (err, stack) => Text('Error: $err'),
    );
  }
}

class dibujarProvncias extends CustomPainter {
  final List<SVGProvincia> layers;
  final Offset? mousePosition;
  dibujarProvncias(this.layers, this.mousePosition);

  Color convertirAColor(String hexColor, {bool opacity = false}) {
    hexColor = hexColor.replaceAll("#", "");

    // le agregamos el 'FF' al principio para la opacidad
    if (hexColor.length == 6) {
      if (opacity) {
        hexColor = "CC$hexColor";
      } else {
        hexColor = "FF$hexColor";
      }
    }

    // 3. Parseamos el string como hexadecimal (base 16)
    return Color(int.parse("0x$hexColor"));
  }

  @override
  void paint(Canvas canvas, Size size) {
    print("Posición del Ratón: $mousePosition");

    double svgWidth = 300;
    double svgHeight = 300;

    double scaleX = size.width / svgWidth;
    double scaleY = size.height / svgHeight;
    double scale = scaleX < scaleY ? scaleX : scaleY; // Aspect ratio contenido

    canvas.scale(scale);

    for (var layer in layers) {
      // Limpiamos las comillas y dividimos por punto y coma
      List<String> properties = layer.estilo.replaceAll('"', '').split(';');

      String fill = "FFFFFF";
      String stroke = "FFFFFF";

      for (var prop in properties) {
        if (prop.contains('fill:#')) {
          fill = prop.split('#').last;
        } else if (prop.contains('stroke:#')) {
          stroke = prop.split('#').last;
        }
      }

      var pincelRelleno = Paint()
        ..color = convertirAColor(fill)
        ..style = PaintingStyle.fill;

      final pincelBorde = Paint()
        ..color = convertirAColor(stroke)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      if (mousePosition != null) {
        final adjustedMousePos = Offset(
          mousePosition!.dx / scale,
          mousePosition!.dy / scale,
        );

        if (layer.path.contains(adjustedMousePos)) {
          pincelRelleno.color = convertirAColor(fill, opacity: true);
        }
      }

      canvas.drawPath(layer.path, pincelBorde);

      canvas.drawPath(layer.path, pincelRelleno);
    }
  }

  @override
  bool shouldRepaint(covariant dibujarProvncias oldDelegate) {
    return oldDelegate.mousePosition != mousePosition ||
        oldDelegate.layers != layers;
  }
}
