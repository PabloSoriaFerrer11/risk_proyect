import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:risk_proyect/provider/mouse_provider.dart';

import 'mapBuilder.dart';

class MapaInteractivo extends ConsumerWidget {
  final String mapId = "mapa_test";

  String provinciaSeleccionada = "Ninguna";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(border: BoxBorder.all()),
                child: MouseRegion(
                  onHover: (event) {
                    ref.read(mousePositionProvider.notifier).state =
                        event.localPosition;
                  },
                  onExit: (_) =>
                      ref.read(mousePositionProvider.notifier).state = null,
                  child: Column(
                    children: [
                      mapBuilder(
                        mapId: mapId,
                        mapWidth: screenSize.width * 0.9,
                        mapHeight: screenSize.height * 0.7,
                      ),
                    ],
                  ),
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
