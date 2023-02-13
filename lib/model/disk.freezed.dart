// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'disk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Disk {
  DiskType get diskType => throw _privateConstructorUsedError;
  int get column => throw _privateConstructorUsedError;
  int get row => throw _privateConstructorUsedError;
  bool get isPlaceable => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DiskCopyWith<Disk> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiskCopyWith<$Res> {
  factory $DiskCopyWith(Disk value, $Res Function(Disk) then) =
      _$DiskCopyWithImpl<$Res, Disk>;
  @useResult
  $Res call({DiskType diskType, int column, int row, bool isPlaceable});
}

/// @nodoc
class _$DiskCopyWithImpl<$Res, $Val extends Disk>
    implements $DiskCopyWith<$Res> {
  _$DiskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? diskType = null,
    Object? column = null,
    Object? row = null,
    Object? isPlaceable = null,
  }) {
    return _then(_value.copyWith(
      diskType: null == diskType
          ? _value.diskType
          : diskType // ignore: cast_nullable_to_non_nullable
              as DiskType,
      column: null == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int,
      row: null == row
          ? _value.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
      isPlaceable: null == isPlaceable
          ? _value.isPlaceable
          : isPlaceable // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DiskCopyWith<$Res> implements $DiskCopyWith<$Res> {
  factory _$$_DiskCopyWith(_$_Disk value, $Res Function(_$_Disk) then) =
      __$$_DiskCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DiskType diskType, int column, int row, bool isPlaceable});
}

/// @nodoc
class __$$_DiskCopyWithImpl<$Res> extends _$DiskCopyWithImpl<$Res, _$_Disk>
    implements _$$_DiskCopyWith<$Res> {
  __$$_DiskCopyWithImpl(_$_Disk _value, $Res Function(_$_Disk) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? diskType = null,
    Object? column = null,
    Object? row = null,
    Object? isPlaceable = null,
  }) {
    return _then(_$_Disk(
      diskType: null == diskType
          ? _value.diskType
          : diskType // ignore: cast_nullable_to_non_nullable
              as DiskType,
      column: null == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int,
      row: null == row
          ? _value.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
      isPlaceable: null == isPlaceable
          ? _value.isPlaceable
          : isPlaceable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Disk with DiagnosticableTreeMixin implements _Disk {
  const _$_Disk(
      {required this.diskType,
      required this.column,
      required this.row,
      required this.isPlaceable});

  @override
  final DiskType diskType;
  @override
  final int column;
  @override
  final int row;
  @override
  final bool isPlaceable;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Disk(diskType: $diskType, column: $column, row: $row, isPlaceable: $isPlaceable)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Disk'))
      ..add(DiagnosticsProperty('diskType', diskType))
      ..add(DiagnosticsProperty('column', column))
      ..add(DiagnosticsProperty('row', row))
      ..add(DiagnosticsProperty('isPlaceable', isPlaceable));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Disk &&
            (identical(other.diskType, diskType) ||
                other.diskType == diskType) &&
            (identical(other.column, column) || other.column == column) &&
            (identical(other.row, row) || other.row == row) &&
            (identical(other.isPlaceable, isPlaceable) ||
                other.isPlaceable == isPlaceable));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, diskType, column, row, isPlaceable);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DiskCopyWith<_$_Disk> get copyWith =>
      __$$_DiskCopyWithImpl<_$_Disk>(this, _$identity);
}

abstract class _Disk implements Disk {
  const factory _Disk(
      {required final DiskType diskType,
      required final int column,
      required final int row,
      required final bool isPlaceable}) = _$_Disk;

  @override
  DiskType get diskType;
  @override
  int get column;
  @override
  int get row;
  @override
  bool get isPlaceable;
  @override
  @JsonKey(ignore: true)
  _$$_DiskCopyWith<_$_Disk> get copyWith => throw _privateConstructorUsedError;
}
