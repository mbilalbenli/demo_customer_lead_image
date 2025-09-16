import 'package:flutter/material.dart';

/// An atom for zoom controls
/// Following atomic design principles
class ZoomControlsAtom extends StatelessWidget {
  final bool isZoomed;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;

  const ZoomControlsAtom({
    super.key,
    this.isZoomed = false,
    this.onZoomIn,
    this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: isZoomed ? null : onZoomIn,
            icon: const Icon(Icons.zoom_in),
            color: Colors.white,
            disabledColor: Colors.white30,
          ),
          Container(
            width: 24,
            height: 1,
            color: Colors.white30,
          ),
          IconButton(
            onPressed: isZoomed ? onZoomOut : null,
            icon: const Icon(Icons.zoom_out),
            color: Colors.white,
            disabledColor: Colors.white30,
          ),
        ],
      ),
    );
  }
}