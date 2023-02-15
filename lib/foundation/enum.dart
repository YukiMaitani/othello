import 'package:flutter/material.dart';

enum DiskType {
  black,
  white,
  none;
}

enum Turn {
  black,
  white;

  Color get color {
    switch (this) {
      case Turn.black:
        return Colors.black;
      case Turn.white:
        return Colors.white;
    }
  }

  Turn get switchTurn {
    switch (this) {
      case Turn.white:
        return Turn.black;
      case Turn.black:
        return Turn.white;
    }
  }

  DiskType get turnDiskType {
    switch (this) {
      case Turn.black:
        return DiskType.black;
      case Turn.white:
        return DiskType.white;
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

enum Result { proceed, pass, filled }
