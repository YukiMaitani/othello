import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:othello/model/disk.dart';

import '../../foundation/enum.dart';

final gameProvider = ChangeNotifierProvider((ref) => GameViewModel());

class GameViewModel extends ChangeNotifier {
  GameViewModel() {
    initDisksType();
  }

  final columnsNumber = 8;
  final rowsNumber = 8;

  late List<List<Disk>> _disks;

  List<List<Disk>> get disks => _disks;

  set disks(List<List<Disk>> value) {
    _disks = value;
    notifyListeners();
  }

  List<Disk> get disksFlatten => disks.expand((disk) => disk).toList();

  Turn _turn = Turn.black;

  Turn get turn => _turn;

  set turn(Turn value) {
    _turn = value;
    notifyListeners();
  }

  int _blackDisksNumber = 2;

  int get blackDisksNumber => _blackDisksNumber;

  set blackDisksNumber(int value) {
    _blackDisksNumber = value;
    notifyListeners();
  }

  int _whiteDisksNumber = 2;

  int get whiteDisksNumber => _whiteDisksNumber;

  set whiteDisksNumber(int value) {
    _whiteDisksNumber = value;
    notifyListeners();
  }

  int get possiblePlaceSquareNumber {
    return disksFlatten.where((disk) => disk.isPlaceable == true).length;
  }


  void initDisksType() {
    _disks = List.generate(
        columnsNumber,
        (column) => List.generate(rowsNumber,
            (row) => Disk(diskType: DiskType.none, column: column, row: row, isPlaceable: false)));
    _disks[3][3] = _disks[3][3].copyWith(diskType: DiskType.white);
    _disks[3][4] = _disks[3][4].copyWith(diskType: DiskType.black);
    _disks[4][3] = _disks[4][3].copyWith(diskType: DiskType.black);
    _disks[4][4] = _disks[4][4].copyWith(diskType: DiskType.white);
    _turn = Turn.black;
    canPlaceDisk(turn);
    _blackDisksNumber = 2;
    _whiteDisksNumber = 2;
    notifyListeners();
  }

  bool isOutOfIndex(int columnIndex, int rowIndex) {
    return columnIndex < 0 ||
        columnIndex > columnsNumber - 1 ||
        rowIndex < 0 ||
        rowIndex > rowsNumber - 1;
  }

  void canPlaceDisk(Turn checkTurn) {
    for(var i = 0;i < columnsNumber;i++) {
      for(var j = 0;j< rowsNumber;j++) {
        final disk = disks[i][j];

        switch (disk.diskType) {
          case DiskType.black:
          case DiskType.white:
            _disks = _disks..[i][j] = disk.copyWith(isPlaceable: false);
            Logger().i('column$i row$j\npossiblePlaceSquareNumber$possiblePlaceSquareNumber');
            break;

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
              if (disks[directionColumn][directionRow].diskType == checkTurn.turnDiskType ||
                  disks[directionColumn][directionRow].diskType == DiskType.none) {
                continue;
              }

              // 方向に相手の駒がある時の処理。その駒から次の駒から調べる。
              var directionLineColumn = directionColumn + direction.column;
              var directionLineRow = directionRow + direction.row;

              // 調べるマスが盤外になったら抜ける
              while (!isOutOfIndex(directionLineColumn, directionLineRow)) {
                // 駒が無ければ抜ける
                if (disks[directionLineColumn][directionLineRow].diskType ==
                    DiskType.none) {
                  break;
                }

                // 自分の駒があれば駒を置ける所。trueを返す
                if (disks[directionLineColumn][directionLineRow].diskType ==
                    checkTurn.turnDiskType) {
                  _disks = _disks..[i][j] = disk.copyWith(isPlaceable: true);
                  Logger().i('column$i row$j\npossiblePlaceSquareNumber$possiblePlaceSquareNumber');
                  break;
                }

                directionLineColumn += direction.column;
                directionLineRow += direction.row;
              }
            }

            if(_disks[i][j].isPlaceable) { break; }

            // ８方向を全て調べて条件に合わなければfalseを返す
            _disks = _disks..[i][j] = disk.copyWith(isPlaceable: false);
            Logger().i('column$i row$j\npossiblePlaceSquareNumber$possiblePlaceSquareNumber');
            break;
        }
      }
    }
    notifyListeners();
  }

  void switchTurn() {
    if(possiblePlaceSquareNumber > 0) {
      _turn = turn.switchTurn;
    }
    notifyListeners();
  }

  void placeDisk(Disk disk) {
    disks[disk.column][disk.row] =
        disks[disk.column][disk.row].copyWith(diskType: turn.turnDiskType);
    notifyListeners();
  }

  void turnOverDisks(Disk disk) {
    final column = disk.column;
    final row = disk.row;
    var turnOverDisksNumber = 0;
    final tempDisks = disks;

    // 駒がない所から８方向の駒について調べる
    for (var direction in Direction.values) {
      final directionColumn = column + direction.column;
      final directionRow = row + direction.row;

      // 盤外であれば抜ける
      if (isOutOfIndex(directionColumn, directionRow)) {
        continue;
      }

      // 手番の人の駒であるまたは駒が無ければ抜ける
      if (tempDisks[directionColumn][directionRow].diskType == turn.turnDiskType ||
          tempDisks[directionColumn][directionRow].diskType == DiskType.none) {
        continue;
      }

      // 方向に相手の駒がある時の処理。その駒から次の駒から調べる。
      var directionLineColumn = directionColumn + direction.column;
      var directionLineRow = directionRow + direction.row;

      // 調べるマスが盤外になったら抜ける
      while (!isOutOfIndex(directionLineColumn, directionLineRow)) {
        // 駒が無ければ抜ける
        if (tempDisks[directionLineColumn][directionLineRow].diskType ==
            DiskType.none) {
          break;
        }

        // 自分の駒があればそこから駒を置いた地点まで駒を返す
        if (tempDisks[directionLineColumn][directionLineRow].diskType ==
            turn.turnDiskType) {
          directionLineColumn -= direction.column;
          directionLineRow -= direction.row;
          do {
            tempDisks[directionLineColumn][directionLineRow] =
                tempDisks[directionLineColumn][directionLineRow]
                    .copyWith(diskType: turn.turnDiskType);
            turnOverDisksNumber++;
            directionLineColumn -= direction.column;
            directionLineRow -= direction.row;
          } while (directionLineColumn != column || directionLineRow != row);

          // 自分の地点に帰って来たら抜ける
          break;
        }

        directionLineColumn += direction.column;
        directionLineRow += direction.row;
      }
      _disks = tempDisks;
    }

    switch (turn) {
      case Turn.black:
        _blackDisksNumber += (turnOverDisksNumber + 1);
        _whiteDisksNumber -= turnOverDisksNumber;
        break;

      case Turn.white:
        _whiteDisksNumber += (turnOverDisksNumber + 1);
        _blackDisksNumber -= turnOverDisksNumber;
        break;
    }

    notifyListeners();
  }

  void onePlay(Disk tappedDisk) {
    placeDisk(tappedDisk);
    turnOverDisks(tappedDisk);
    canPlaceDisk(turn.switchTurn);
    switchTurn();
    notifyListeners();
  }

}
