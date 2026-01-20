import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class MatchScreen extends StatefulWidget {
  final String peladaId;
  const MatchScreen({super.key, required this.peladaId});
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<String> timeA = [];
  List<String> timeB = [];
  List<dynamic> fila = [];
  int somaA = 0;
  int somaB = 0;
  int streakTimeA = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGameState();
  }

  Future<void> _loadGameState() async {
    try {
      final data = await ApiService().fetchGameState(widget.peladaId);
      if (data != null) {
        setState(() {
          timeA = List<String>.from(data['timeA'] ?? []);
          timeB = List<String>.from(data['timeB'] ?? []);
          fila = data['fila'] ?? [];
          somaA = data['somaA'] ?? 0;
          somaB = data['somaB'] ?? 0;
          streakTimeA = data['streakTimeA'] ?? 0;
          isLoading = false;
        });
      } else { setState(() => isLoading = false); }
    } catch (e) { setState(() => isLoading = false); }
  }

  void _confirmarVitoria(String vencedor) async {
    setState(() => isLoading = true);
    try {
      final novo = await ApiService().finishMatch(widget.peladaId, vencedor);
      setState(() {
        timeA = List<String>.from(novo['timeA']);
        timeB = List<String>.from(novo['timeB']);
        fila = novo['fila'];
        somaA = novo['somaA'];
        somaB = novo['somaB'];
        streakTimeA = novo['streakTimeA'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e")));
    }
  }

  Future<void> _encerrarPelada() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Encerrar Pelada?"),
        content: const Text("Isso calculará a Seleção e limpará o jogo atual."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("CANCELAR")),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("ENCERRAR")),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => isLoading = true);
      try {
        await ApiService().deleteGameState(widget.peladaId);
        Navigator.pop(context);
      } catch (e) { setState(() => isLoading = false); }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: X5Colors.primaryGreen)));
    if (timeA.isEmpty) return Scaffold(appBar: AppBar(title: const Text("X5 BOT")), body: const Center(child: Text("Partida não encontrada.")));

    return Scaffold(
      appBar: AppBar(title: const Text("PARTIDA ATUAL"), actions: [
        IconButton(icon: const Icon(Icons.stop_circle_outlined, color: X5Colors.danger), onPressed: _encerrarPelada)
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _buildStreakHeader(),
          const SizedBox(height: 24),
          _buildVersusCard(),
          const SizedBox(height: 32),
          _buildActionButtons(),
          const SizedBox(height: 32),
          _buildManagementButtons(),
          const SizedBox(height: 40),
          _buildQueueSection(),
        ]),
      ),
    );
  }

  Widget _buildStreakHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: X5Colors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.withOpacity(0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Text("STREAK TIME A: ", style: TextStyle(color: X5Colors.textSecondary)),
        Text("🔥 $streakTimeA", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
      ]),
    );
  }

  Widget _buildVersusCard() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: _buildTeamColumn("TIME A", timeA, X5Colors.primaryGreen, somaA)),
      const Padding(padding: EdgeInsets.only(top: 80), child: Text("VS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white24))),
      Expanded(child: _buildTeamColumn("TIME B", timeB, Colors.white, somaB)),
    ]);
  }

  Widget _buildTeamColumn(String label, List<String> players, Color color, int soma) {
    return Column(children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      Text("Soma: $soma", style: const TextStyle(fontSize: 11, color: X5Colors.textSecondary, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ...players.map((p) => Card(child: Container(width: double.infinity, padding: const EdgeInsets.all(14), child: Text(p, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))))),
    ]);
  }

  Widget _buildActionButtons() {
    return Row(children: [
      Expanded(child: ElevatedButton(onPressed: () => _confirmarVitoria('A'), style: ElevatedButton.styleFrom(backgroundColor: X5Colors.primaryGreen, padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text("VITÓRIA A", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
      const SizedBox(width: 12),
      Expanded(child: ElevatedButton(onPressed: () => _confirmarVitoria('B'), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text("VITÓRIA B", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
    ]);
  }

  Widget _buildManagementButtons() {
    return Row(children: [
      Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.person_add, size: 18), label: const Text("Atrasados"))),
      const SizedBox(width: 12),
      Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.person_remove, size: 18), label: const Text("Saída"))),
    ]);
  }

  Widget _buildQueueSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("FILA DE ESPERA", style: TextStyle(fontWeight: FontWeight.bold, color: X5Colors.textSecondary)),
      const SizedBox(height: 12),
      ...fila.asMap().entries.map((entry) {
        final time = entry.value;
        return Card(color: Colors.white.withOpacity(0.03), child: ListTile(
          leading: Text("${entry.key + 1}º", style: const TextStyle(color: X5Colors.primaryGreen, fontWeight: FontWeight.bold)),
          title: Text(List<String>.from(time['jogadores'] ?? []).join(", "), style: const TextStyle(fontSize: 13)),
          trailing: Text("Σ ${time['soma'] ?? 0}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white38)),
        ));
      }).toList(),
    ]);
  }
}