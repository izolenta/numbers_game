class Direction {
  static const Direction left = const Direction._(0);
  static const Direction top = const Direction._(1);
  static const Direction right = const Direction._(2);
  static const Direction bottom = const Direction._(3);

  final int value;

  const Direction._(this.value);

  @override
  String toString() => value.toString();

}
