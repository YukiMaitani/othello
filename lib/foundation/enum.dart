import 'dart:ui';

import 'package:flutter/material.dart';

enum DiskType {
  black('黒'),
  white('白'),
  none('無'),
  ;

  const DiskType(this.text);

  final String text;
}

enum Turn {
  black('黒番'),
  white('白番'),
  ;

  const Turn(this.text);

  final String text;

  Color get color {
    switch (this) {
      case Turn.black:
        return Colors.black;
      case Turn.white:
        return Colors.white;
    }
  }

  Color get reverseColor {
    switch (this) {
      case Turn.white:
        return Colors.black;
      case Turn.black:
        return Colors.white;
    }
  }
}

enum Direction {
  up,
  down,
  left,
  right,
  upLeft,
  upRight,
  downLeft,
  downRight;

  int get row {
    switch (this) {
      case Direction.up:
      case Direction.down:
        return 0;
      case Direction.left:
      case Direction.upLeft:
      case Direction.downLeft:
        return -1;
      case Direction.right:
      case Direction.upRight:
      case Direction.downRight:
        return 1;
    }
  }

  int get column {
    switch (this) {
      case Direction.right:
      case Direction.left:
        return 0;
      case Direction.down:
      case Direction.downRight:
      case Direction.downLeft:
        return 1;
      case Direction.up:
      case Direction.upRight:
      case Direction.upLeft:
        return -1;
    }
  }
}
