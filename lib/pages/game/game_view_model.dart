import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../foundation/enum.dart';

final gameProvider = ChangeNotifierProvider((ref) => GameViewModel());

class GameViewModel extends ChangeNotifier {
  GameViewModel() {
    initDisksType();
  }

  final columnsNumber = 8;
  final rowsNumber = 8;

  late List<List<DiskType>> disksType;

  List<DiskType> get disksTypeFlatten =>
      disksType.expand((diskType) => diskType).toList();

  void initDisksType() {
    disksType = List.generate(
        columnsNumber, (_) => List.generate(rowsNumber, (_) => DiskType.none));
    disksType[3][3] = DiskType.white;
    disksType[3][4] = DiskType.black;
    disksType[4][3] = DiskType.black;
    disksType[4][4] = DiskType.white;
  }
}
