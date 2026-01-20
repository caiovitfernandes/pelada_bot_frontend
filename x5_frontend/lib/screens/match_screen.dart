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
  int streakTimeA = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGameState(); // Busca do banco ao abrir a tela
  }

  // Busca o estado que está salvo no Azure
  Future<void> _loadGameState() async {
    try {
      final data = await ApiService().fetchGameState(widget.peladaId);
      if (data != null) {
        setState(() {
          // Decodifica as strings JSON que o Azure Table armazena
          timeA = List<String>.from(jsonDecode(data['TimeA'] ?? '[]'));
          timeB = List<String>.from(jsonDecode(data['TimeB'] ?? '[]'));
          fila = jsonDecode(data['Fila'] ?? '[]');
          streakTimeA = data['streakTimeA'] ?? 0;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Erro ao carregar estado: $e");
    }
  }

  void _confirmarVitoria(String vencedor) async {
    setState(() => isLoading = true);
    try {
      // O BACKEND resolve tudo: Rating, Gira Fila, Salva Estado e devolve pra gente
      final novoEstado = await ApiService().finishMatch(widget.peladaId, vencedor);

      setState(() {
        timeA = List<String>.from(novoEstado['timeA']);
        timeB = List<String>.from(novoEstado['timeB']);
        fila = novoEstado['fila'];
        streakTimeA = novoEstado['streakTimeA'];
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resultado aplicado com sucesso!")),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: X5Colors.primaryGreen)));
    
    if (timeA.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("X5 BOT")),
        body: const Center(child: Text("Nenhuma partida em andamento.\nInicie pelo Sorteio.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("PARTIDA EM ANDAMENTO"),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStreakHeader(),
            const SizedBox(height: 24),
            _buildVersusCard(),
            const SizedBox(height: 32),
            _buildActionButtons(),
            const SizedBox(height: 40),
            _buildQueueSection(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE INTERFACE ---

  Widget _buildStreakHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: X5Colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3))
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("STREAK TIME A: ", style: TextStyle(color: X5Colors.textSecondary)),
          Text("🔥 $streakTimeA", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildVersusCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildTeamColumn("TIME A", timeA, X5Colors.primaryGreen)),
        const Padding(
          padding: EdgeInsets.only(top: 100),
          child: Text("VS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white24)),
        ),
        Expanded(child: _buildTeamColumn("TIME B", timeB, Colors.white)),
      ],
    );
  }

  Widget _buildTeamColumn(String label, List<String> players, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 12),
        ...players.map((p) => Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            child: Text(p, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        )),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _confirmarVitoria('A'),
            style: ElevatedButton.styleFrom(backgroundColor: X5Colors.primaryGreen, padding: const EdgeInsets.symmetric(vertical: 20)),
            child: const Text("VITÓRIA A", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _confirmarVitoria('B'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20)),
            child: const Text("VITÓRIA B", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildQueueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("FILA DE ESPERA", style: TextStyle(fontWeight: FontWeight.bold, color: X5Colors.textSecondary)),
        const SizedBox(height: 12),
        ...fila.asMap().entries.map((entry) => Card(
          color: Colors.white.withOpacity(0.03),
          child: ListTile(
            leading: Text("${entry.key + 1}º", style: const TextStyle(color: X5Colors.primaryGreen)),
            title: Text(List<String>.from(entry.value).join(", "), style: const TextStyle(fontSize: 14)),
          ),
        )).toList(),
      ],
    );
  }
}