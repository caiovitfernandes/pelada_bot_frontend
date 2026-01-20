import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';

class SetupMatchScreen extends StatefulWidget {
  final String peladaId;
  const SetupMatchScreen({super.key, required this.peladaId});

  @override
  State<SetupMatchScreen> createState() => _SetupMatchScreenState();
}

class _SetupMatchScreenState extends State<SetupMatchScreen> {
  List<String> selecionados = [];
  int tamanhoTime = 6;
  bool processando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Sorteio")),
      body: FutureBuilder<List<Player>>(
        future: ApiService().fetchPlayers(widget.peladaId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: X5Colors.primaryGreen));
          
          final players = snapshot.data!;
          players.sort((a, b) => a.name.compareTo(b.name));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Jogadores por time:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    DropdownButton<int>(
                      value: tamanhoTime,
                      items: [2, 4, 5, 6].map((e) => DropdownMenuItem(value: e, child: Text("$e Atletas"))).toList(),
                      onChanged: (v) => setState(() => tamanhoTime = v!),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final p = players[index];
                    return CheckboxListTile(
                      activeColor: X5Colors.primaryGreen,
                      title: Text(p.name),
                      value: selecionados.contains(p.name),
                      onChanged: (val) {
                        setState(() {
                          if (val!) { selecionados.add(p.name); } 
                          else { selecionados.remove(p.name); }
                        });
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: X5Colors.primaryGreen,
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: processando ? null : () async {
                    if (selecionados.length < (tamanhoTime * 2)) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecione jogadores suficientes para pelo menos 2 times!")));
                      return;
                    }
                    
                    setState(() => processando = true);
                    try {
                      // Chama a rota que você testou no Postman, mas via App
                      await ApiService().initializeMatch(widget.peladaId, selecionados, tamanhoTime);
                      Navigator.pop(context); // Volta para a home
                    } catch (e) {
                      setState(() => processando = false);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao sortear: $e")));
                    }
                  }, 
                  child: processando 
                    ? const CircularProgressIndicator(color: Colors.black) 
                    : const Text("SORTEAR E INICIAR PARTIDA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}