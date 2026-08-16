import 'package:flutter/material.dart';

/// Reusable icon component for SCAM INC. assets.
class ScamIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? color;
  final BoxFit fit;

  const ScamIcon({
    super.key,
    required this.assetPath,
    this.size = 24.0,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      color: color,
      fit: fit,
      gaplessPlayback: true,
      filterQuality: FilterQuality.low,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.broken_image_outlined,
          size: size,
          color: Colors.grey,
        );
      },
    );
  }
}
