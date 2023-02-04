import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../foundation/enum.dart';

final gameProvider = ChangeNotifierProvider((ref) => GameViewModel());

class GameViewModel extends ChangeNotifier {
  
  List<DiskType> get disksType {
    return disksText.map((name) => DiskType.values.byName(name)).toList();
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