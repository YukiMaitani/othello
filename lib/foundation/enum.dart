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
}