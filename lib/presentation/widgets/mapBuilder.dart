import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:risk_proyect/data/models/SVGProvincia.dart';
import 'package:xml/xml.dart';

// StreamBuilder o FutureBuilder
class mapBuilder extends StatelessWidget {
  final String mapId;

  const mapBuilder({super.key, required this.mapId});

  Future<Object> createMap(BuildContext context) async {
    List<SVGProvincia> provincias = [];
    String svgString;
    final cordsReg = RegExp(r"[-+]?\d*\.?\d+");

    try {
      svgString = await rootBundle.loadString('assets/data/$mapId.svg');
    } catch (e) {
      svgString = "";
      return "Error al intentar obtener el mapa";
    }
    final document = XmlDocument.parse(svgString);

    final paths = document.findAllElements('path');

    for (var element in paths) {
      String label = element.getAttribute('label') ?? 'Sin nombre';
      String data = element.getAttribute('d') ?? '';
      String style = element.getAttribute('style') ?? '';
      String transform = element.getAttribute('transform') ?? '';

      Path flutterPath = parseSvgPathData(data);
      if (transform.contains("translate")) {
        List<double> coords = cordsReg
            .allMatches(transform)
            .map((m) => double.parse(m.group(0)!))
            .toList();

        flutterPath = flutterPath.transform(
          Matrix4.translationValues(coords[0], coords[1], 0).storage,
        );
      }
      provincias.add(
        SVGProvincia(label: label, path: flutterPath, estilo: style),
      );
    }

    return provincias;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: createMap(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data');
        }
        var data = snapshot.data;
        if (data is String) {
          return Text(data);
        }
        if (data is List<SVGProvincia>) {
          return CustomPaint(
            size: Size.infinite,

            painter: dibujarProvncias(data),
          );
        }
        return Text("");
      },
    );
  }
}

class dibujarProvncias extends CustomPainter {
  final List<SVGProvincia> layers;

  dibujarProvncias(this.layers);

  Color convertirAColor(String hexColor) {
    // 1. Limpiamos el string por si trae el '#'
    hexColor = hexColor.replaceAll("#", "");

    // 2. Si el string tiene 6 caracteres (RRGGBB),
    // le agregamos el 'FF' al principio para la opacidad
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    // 3. Parseamos el string como hexadecimal (base 16)
    return Color(int.parse("0x$hexColor"));
  }

  @override
  void paint(Canvas canvas, Size size) {
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

      final pincelRelleno = Paint()
        ..color = convertirAColor(fill)
        ..style = PaintingStyle.fill;

      final pincelBorde = Paint()
        ..color = convertirAColor(stroke)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawPath(layer.path, pincelBorde);

      canvas.drawPath(layer.path, pincelRelleno);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
