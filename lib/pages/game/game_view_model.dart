import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../foundation/enum.dart';

final gameProvider = ChangeNotifierProvider((ref) => GameViewModel());

class GameViewModel extends ChangeNotifier {

  List<DiskType> get disksType {
    final disksType = disksText.map((name){
      if(name == '黒') {
        return DiskType.black;
      }

      if(name == '白') {
        return DiskType.white;
      }

      return DiskType.none;
    }).toList();
    return disksType;
  }

  List<String> _disksText =
  [
    '無','無','無','無','無','無','無','無',
    '無','無','無','無','無','無','無','無',
    '無','無','無','無','無','無','無','無',
    '無','無','無','白','黒','無','無','無',
    '無','無','無','黒','白','無','無','無',
    '無','無','無','無','無','無','無','無',
    '無','無','無','無','無','無','無','無',
    '無','無','無','無','無','無','無','無',
  ];

  List<String> get disksText => _disksText;

  set disksText(value) {
    _disksText = value;
    notifyListeners();
  }
}