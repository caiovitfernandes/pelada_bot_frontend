class Player {
  final String name;
  final int rating;
  final int vitorias;
  final int derrotas;
  final double winrate;

  Player({required this.name, required this.rating, this.vitorias = 0, this.derrotas = 0, this.winrate = 0.0});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['RowKey'],
      rating: json['Rating'],
      vitorias: json['Vitorias'] ?? 0,
      derrotas: json['Derrotas'] ?? 0,
      winrate: (json['Winrate'] ?? 0).toDouble(),
    );
  }
}