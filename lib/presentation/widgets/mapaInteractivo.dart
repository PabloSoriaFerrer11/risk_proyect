import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:risk_proyect/presentation/widgets/mapBuilder.dart';

class MapaInteractivo extends StatefulWidget {
  final String mapId = "mapa_test";
  @override
  _MapaInteractivoState createState() => _MapaInteractivoState();
}

class _MapaInteractivoState extends State<MapaInteractivo> {
  String provinciaSeleccionada = "Ninguna";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(border: BoxBorder.all()),
                child: GestureDetector(
                  onTapUp: (details) {
                    // Aquí lógica para detectar qué provincia tocaste
                    print("Tocaste en: ${details.localPosition}");
                  },
                  child: mapBuilder(mapId: widget.mapId),
                  /*
                  * SvgImage(
                    assetPath: 'assets/data/mapa_test.svg',
                    width: screenSize.width * 0.9,
                    height: screenSize.height * 0.7,
                    color: Colors.blue,
                  )
                  * */
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Para probar guay pero no sirve
class SvgImage extends StatelessWidget {
  const SvgImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
