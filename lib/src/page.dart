import 'dart:io';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';

class PDFPage extends StatefulWidget {
  final String imgPath;
  final int num;
  final double initialRotation;
  final int zoomSteps;
  final double minScale;
  final double panLimit;
  final double maxScale;

  PDFPage(this.imgPath, this.initialRotation, this.zoomSteps, this.minScale,
      this.panLimit, this.maxScale, this.num);

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  ImageProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repaint();
  }

  @override
  void didUpdateWidget(PDFPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imgPath != widget.imgPath) {
      _repaint();
    }
  }

  _repaint() {
    provider = FileImage(File(widget.imgPath));
    final resolver = provider.resolve(createLocalImageConfiguration(context));
    resolver.addListener(ImageStreamListener((imgInfo, alreadyPainted) {
      if (!alreadyPainted) setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: null,
        child: ZoomableWidget(
          initialRotation: widget.initialRotation ?? 0.0,
          zoomSteps: widget.zoomSteps ?? 3,
          minScale: widget.minScale ?? 1.0,
          panLimit: widget.panLimit ?? 0.8,
          maxScale: widget.maxScale ?? 3.0,
          child: Image(image: provider),
        ));
  }
}
