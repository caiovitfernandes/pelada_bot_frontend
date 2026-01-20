import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';
import 'match_screen.dart';
import '../models/selection_player.dart';
import 'manage_players_screen.dart'; // Você precisará criar estes arquivos
import 'setup_match_screen.dart';

class HomeScreen extends StatefulWidget {
  final String peladaId;

  const HomeScreen({super.key, required this.peladaId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variáveis marcadas como late precisam do initState ou Hot Restart
  late Future<List<Player>> futurePlayers;
  late Future<List<SelectionPlayer>> futureSelection;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _loadAllData() {
    futurePlayers = ApiService().fetchPlayers(widget.peladaId);
    futureSelection = ApiService().fetchLastSelection(widget.peladaId);
  }

  void _refreshData() {
    setState(() {
      _loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("X5 BOT (${widget.peladaId})", 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: _refreshData,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildBadge(),
              const SizedBox(height: 20),
              const Text("Organize suas\nPeladas como um\nProfissional", 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2)),
              const SizedBox(height: 30),
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton("Ver Partida Atual", Icons.sports_soccer, X5Colors.primaryGreen, () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => MatchScreen(peladaId: widget.peladaId))
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton("Novo Sorteio", Icons.shuffle, Colors.white, () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => SetupMatchScreen(peladaId: widget.peladaId))
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionButton("Atletas", Icons.group_add, Colors.white10, () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ManagePlayersScreen(peladaId: widget.peladaId))
                      );
                    }),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // SEÇÃO DA SELEÇÃO
              _buildLastSelectionSection(),
              
              const Align(
                alignment: Alignment.centerLeft, 
                child: Text("Ranking Geral", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
              const SizedBox(height: 15),

              // LISTA DO RANKING
              FutureBuilder<List<Player>>(
                future: futurePlayers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: X5Colors.primaryGreen));
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erro: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Nenhum jogador encontrado."));
                  }

                  final players = List<Player>.from(snapshot.data!);
                  
                  // Lógica de ordenação idêntica à original
                  players.sort((a, b) {
                    int cmp = b.rating.compareTo(a.rating);
                    if (cmp != 0) return cmp;
                    cmp = b.winrate.compareTo(a.winrate);
                    if (cmp != 0) return cmp;
                    cmp = b.vitorias.compareTo(a.vitorias);
                    if (cmp != 0) return cmp;
                    cmp = a.derrotas.compareTo(b.derrotas);
                    if (cmp != 0) return cmp;
                    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
                  });

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: index < 3 ? X5Colors.primaryGreen : X5Colors.surface,
                            child: Text("${index + 1}º", 
                              style: TextStyle(color: index < 3 ? Colors.black : X5Colors.primaryGreen, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("V: ${player.vitorias} | D: ${player.derrotas} | WR: ${player.winrate.toStringAsFixed(1)}%"),
                          trailing: Text("${player.rating} pts", 
                            style: const TextStyle(color: X5Colors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastSelectionSection() {
    return FutureBuilder<List<SelectionPlayer>>(
      future: futureSelection,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final selecao = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.stars, color: Colors.amber, size: 22),
                SizedBox(width: 8),
                Text("Destaques da Última Pelada", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selecao.length,
                itemBuilder: (context, index) {
                  final s = selecao[index];
                  final isPositive = s.delta >= 0;

                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: X5Colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isPositive 
                            ? X5Colors.primaryGreen.withOpacity(0.4) 
                            : X5Colors.danger.withOpacity(0.4)
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        Text("${isPositive ? '+' : ''}${s.delta}",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isPositive ? X5Colors.primaryGreen : X5Colors.danger)),
                        Text("Rating: ${s.ratingFinal}", style: const TextStyle(fontSize: 12, color: X5Colors.textSecondary)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.white10),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black),
      label: Text(text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: X5Colors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: X5Colors.primaryGreen.withOpacity(0.5)) // CORRIGIDO: Border.all
      ),
      child: const Text("⚡ A nova era das peladas chegou", style: TextStyle(color: X5Colors.primaryGreen, fontSize: 12)),
    );
  }
}