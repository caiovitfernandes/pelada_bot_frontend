class SelectionPlayer {
  final String name;
  final int delta;
  final int ratingFinal;

  SelectionPlayer({
    required this.name,
    required this.delta,
    required this.ratingFinal,
  });

  factory SelectionPlayer.fromJson(Map<String, dynamic> json) {
    return SelectionPlayer(
      name: json['nome'],
      delta: json['delta'],
      ratingFinal: json['ratingFinal'],
    );
  }
}