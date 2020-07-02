import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';



class PlaceRecog extends StatefulWidget {
  final List<CameraDescription> cameras;
  PlaceRecog(this.cameras);
  @override
  _PlaceRecogState createState() => _PlaceRecogState();
}

class _PlaceRecogState extends State<PlaceRecog> {
  CameraController controller;
  @override
  void initState() {
    super.initState();
    controller =
         CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  if (!controller.value.isInitialized) {
      return new Container();
    }
    return new AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child:  CameraPreview(controller),
    );
  }
}