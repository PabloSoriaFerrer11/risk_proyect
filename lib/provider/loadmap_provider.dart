import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:risk_proyect/data/models/SVGProvincia.dart';
import 'package:xml/xml.dart';

final mapaDataProvider = FutureProvider.family<List<SVGProvincia>, String>((
  ref,
  mapId,
) async {
  List<SVGProvincia> provincias = [];
  String svgString;
  final cordsReg = RegExp(r"[-+]?\d*\.?\d+");

  try {
    svgString = await rootBundle.loadString('assets/data/$mapId.svg');
  } catch (e) {
    print("Error al cargar el SVG: $e");
    svgString = "";
    return [];
  }
  final document = XmlDocument.parse(svgString);

  final paths = document.findAllElements('path');

  for (var element in paths) {
    String label = element.getAttribute('inkscape:label') ?? 'Sin nombre';
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
    if (transform.contains("rotate")) {
      List<double> coords = cordsReg
          .allMatches(transform)
          .map((m) => double.parse(m.group(0)!))
          .toList();

      double radianes = coords[0] * (math.pi / 180);
      final matrix = Matrix4.identity()
        ..translate(
          coords[1],
          coords[2],
        ) // 3. Lo devuelve a su posición original
        ..rotateZ(radianes) // 2. Lo rota
        ..translate(
          -coords[1],
          -coords[2],
        ); // 1. Lo lleva al (0,0) respecto al punto de giro
      flutterPath = flutterPath.transform(matrix.storage);
    }
    provincias.add(
      SVGProvincia(label: label, path: flutterPath, estilo: style),
    );
  }

  return provincias;
});
