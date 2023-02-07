import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

  DiskType get turnDiskType => DiskType.values.byName(turn.name);

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

  bool _isHavePossiblePlaceDiskSquare = false;

  bool get isHavePossiblePlaceDiskSquare => _isHavePossiblePlaceDiskSquare;

  set isHavePossiblePlaceDiskSquare(bool value) {
    _isHavePossiblePlaceDiskSquare = value;
    notifyListeners();
  }


  void initDisksType() {
    _disks = List.generate(
        columnsNumber,
        (column) => List.generate(rowsNumber,
            (row) => Disk(diskType: DiskType.none, column: column, row: row)));
    _disks[3][3] = _disks[3][3].copyWith(diskType: DiskType.white);
    _disks[3][4] = _disks[3][4].copyWith(diskType: DiskType.black);
    _disks[4][3] = _disks[4][3].copyWith(diskType: DiskType.black);
    _disks[4][4] = _disks[4][4].copyWith(diskType: DiskType.white);
    notifyListeners();
  }

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
                turnDiskType) {
              _isHavePossiblePlaceDiskSquare = true;
              return true;
            }

            directionLineColumn += direction.column;
            directionLineRow += direction.row;
          }
        }

        // ８方向を全て調べて条件に合わなければfalseを返す
        return false;
    }
  }

  void switchTurn() {
    _turn = turn.switchTurn;
    notifyListeners();
  }

  void placeDisk(Disk disk) {
    disks[disk.column][disk.row] =
        disks[disk.column][disk.row].copyWith(diskType: turnDiskType);
    notifyListeners();
  }

  void turnOverDisks(Disk disk) {
    final column = disk.column;
    final row = disk.row;
    var turnOverDisksNumber = 0;

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

        // 自分の駒があればそこから駒を置いた地点まで駒を返す
        if (disks[directionLineColumn][directionLineRow].diskType ==
            turnDiskType) {
          directionLineColumn -= direction.column;
          directionLineRow -= direction.row;
          do {
            _disks[directionLineColumn][directionLineRow] =
                disks[directionLineColumn][directionLineRow]
                    .copyWith(diskType: turnDiskType);
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

  Future<void> turnContinueOrSkip(Future<void> showDialog) async{
    if(!isHavePossiblePlaceDiskSquare) {
      await showDialog;
      switchTurn();
    }
    _isHavePossiblePlaceDiskSquare = false;
  }

  void onePlay(Disk disk) {
    placeDisk(disk);
    turnOverDisks(disk);
    switchTurn();
    notifyListeners();
  }

}
