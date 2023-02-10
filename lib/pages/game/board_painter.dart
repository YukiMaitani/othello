import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/enum.dart';
import '../../model/disk.dart';

class BoardPainter extends CustomPainter {
  BoardPainter(this.disks);

  final List<Disk> disks;

  @override
  void paint(Canvas canvas, Size size) {
    final squareWidth = size.width / 8;
    final squareHeight = size.height / 8;
    final diskRadius = squareWidth - 30;
    final pathPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 8; i++) {
      final rowPath = Path()
        ..moveTo(squareWidth * i, 0)
        ..lineTo(squareWidth * i, squareHeight * 8);
      final columnPath = Path()
        ..moveTo(0, squareHeight * i)
        ..lineTo(squareWidth * 8, squareHeight * i);
      canvas.drawPath(rowPath, pathPaint);
      canvas.drawPath(columnPath, pathPaint);
    }

    for (final disk in disks) {
      switch (disk.diskType) {
        case DiskType.black:
          final centerOffset = Offset(
              squareWidth * (disk.row + 1) - squareWidth / 2,
              squareHeight * (disk.column + 1) - squareHeight / 2);
          canvas.drawCircle(
              centerOffset, diskRadius, Paint()..color = Colors.black);
          break;
        case DiskType.white:
          final centerOffset = Offset(
              squareWidth * (disk.row + 1) - squareWidth / 2,
              squareHeight * (disk.column + 1) - squareHeight / 2);
          canvas.drawCircle(
              centerOffset, diskRadius, Paint()..color = Colors.white);
          break;
        case DiskType.none:
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
