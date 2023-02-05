import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:othello/foundation/enum.dart';
part 'disk.freezed.dart';

@freezed
class Disk with _$Disk {
  const factory Disk({
    required DiskType diskType,
    required int column,
    required int row,
  }) = _Disk;

}
