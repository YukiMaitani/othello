import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:othello/model/disk.dart';

import '../../foundation/enum.dart';

final gameProvider = ChangeNotifierProvider((ref) => GameViewModel());

class GameViewModel extends ChangeNotifier {
  GameViewModel() {
    initDisksType();
    notifyListeners();
  }

  final columnsNumber = 8;
  final rowsNumber = 8;

  late List<List<Disk>> disks;

  List<Disk> get disksFlatten => disks.expand((disk) => disk).toList();

  void initDisksType() {
    disks = List.generate(
        columnsNumber,
        (column) => List.generate(rowsNumber,
            (row) => Disk(diskType: DiskType.none, column: column, row: row)));
    disks[3][3] = disks[3][3].copyWith(diskType: DiskType.white);
    disks[3][4] = disks[3][4].copyWith(diskType: DiskType.black);
    disks[4][3] = disks[4][3].copyWith(diskType: DiskType.black);
    disks[4][4] = disks[4][4].copyWith(diskType: DiskType.white);
  }

  Turn _turn = Turn.black;

  Turn get turn => _turn;

  set turn(value) {
    _turn = value;
    notifyListeners();
  }

  DiskType get turnDiskType => DiskType.values.byName(turn.name);

  bool isOutOfIndex(int columnIndex, int rowIndex) {
    return columnIndex < 0 ||
        columnIndex > columnsNumber - 1 ||
        rowIndex < 0 ||
        rowIndex > rowsNumber - 1;
  }

  bool isPossiblePlaceDisk(
    Disk disk,
  ) {
    switch (disk.diskType) {
      case DiskType.black:
      case DiskType.white:
        return false;

      case DiskType.none:
        final column = disk.column;
        final row = disk.row;
        // 駒がない所から８方向の駒について調べる
        for (var direction in Direction.values) {
          final directionColumn = column + direction.column;
          final directionRow = row + direction.row;

          // 盤外であれば抜ける
          if (isOutOfIndex(directionColumn, directionRow)) {
            continue;
          }

          // 手番の人の駒であるまたは駒が無ければ抜ける
          if (disks[directionColumn][directionRow].diskType == turnDiskType ||
              disks[directionColumn][directionRow].diskType == DiskType.none) {
            continue;
          }

          var directionLineColumn = directionColumn + direction.column;
          var directionLineRow = directionRow + direction.row;
          Logger().i(
              'column: $column row: $row\ndirectionLineColumn: $directionLineColumn directionLineRow: $directionLineRow\nisOutOfIndex: ${isOutOfIndex(directionLineColumn, directionLineRow)}');
          while (!isOutOfIndex(directionLineColumn, directionLineRow)) {
            if (disks[directionLineColumn][directionLineRow].diskType ==
                DiskType.none) {
              Logger().i(
                  '駒がないので抜ける\ndirectionLineColumn: $directionLineColumn directionLineRow $directionLineRow');
              directionLineColumn += direction.column;
              directionLineRow += direction.row;
              break;
            }

            if (disks[directionLineColumn][directionLineRow].diskType ==
                turnDiskType) {
              Logger().i('true!\n column: $column row: $row');
              return true;
            }

            Logger().i(
                'column: $column row: $row \n directionLineColumn: $directionLineColumn directionLineRow: $directionLineRow');
            directionLineColumn += direction.column;
            directionLineRow += direction.row;
          }
        }

        // ８方向を全て調べて条件に合わなければfalseを返す
        return false;
    }
  }
}
