import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';

class ManagePlayersScreen extends StatefulWidget {
  final String peladaId;
  const ManagePlayersScreen({super.key, required this.peladaId});

  @override
  State<ManagePlayersScreen> createState() => _ManagePlayersScreenState();
}

class _ManagePlayersScreenState extends State<ManagePlayersScreen> {
  final _nomeController = TextEditingController();
  late Future<List<Player>> _futurePlayers;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _futurePlayers = ApiService().fetchPlayers(widget.peladaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Banco de Atletas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: "Nome do novo jogador",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_circle, color: X5Colors.primaryGreen, size: 30),
                  onPressed: () async {
                    if (_nomeController.text.trim().isEmpty) return;
                    await ApiService().addPlayer(widget.peladaId, _nomeController.text);
                    _nomeController.clear();
                    _refresh();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Player>>(
                future: _futurePlayers,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final players = snapshot.data!;
                  players.sort((a, b) => a.name.compareTo(b.name));
                  
                  return ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final p = players[index];
                      return ListTile(
                        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Rating: ${p.rating}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: X5Colors.danger),
                          onPressed: () async {
                            final confirm = await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Remover jogador?"),
                                content: Text("Isso apagará permanentemente o histórico de ${p.name}."),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("CANCELAR")),
                                  ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("REMOVER")),
                                ],
                              )
                            );
                            if (confirm == true) {
                              await ApiService().deletePlayer(widget.peladaId, p.name);
                              _refresh();
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}