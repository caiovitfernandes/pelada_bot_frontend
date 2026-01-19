import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<String> timeA = ["Carlos", "Sávio", "Wanderson", "Caio", "Lais", "Diego"];
  List<String> timeB = ["Beto", "André", "Lucas", "Tiago", "João", "Felipe"];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PARTIDA ATUAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildScoreBoard(),
            const SizedBox(height: 24),
            _buildTeamsDisplay(),
            const SizedBox(height: 32),
            _buildActionButtons(),
            const SizedBox(height: 40),
            _buildQueue(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: BoxDecoration(
        color: X5Colors.surface,
        borderRadius: BorderRadius.circular(20),
        // CORREÇÃO: BorderSide -> Border.all
        border: Border.all(color: X5Colors.primaryGreen.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("TIME A", style: TextStyle(fontWeight: FontWeight.bold, color: X5Colors.primaryGreen)),
          Text("VS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white24)),
          Text("TIME B", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTeamsDisplay() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildPlayerList(timeA, true)),
        const SizedBox(width: 16),
        Expanded(child: _buildPlayerList(timeB, false)),
      ],
    );
  }

  Widget _buildPlayerList(List<String> players, bool isTeamA) {
    return Column(
      children: players.map((p) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isTeamA ? X5Colors.primaryGreen.withOpacity(0.1) : X5Colors.surface,
          borderRadius: BorderRadius.circular(12),
          // CORREÇÃO: BorderSide -> Border.all
          border: Border.all(color: isTeamA ? X5Colors.primaryGreen : X5Colors.cardBorder),
        ),
        child: Text(p, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
      )).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildWinButton("VITÓRIA A", X5Colors.primaryGreen)),
            const SizedBox(width: 12),
            Expanded(child: _buildWinButton("VITÓRIA B", Colors.white)),
          ],
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {}, 
          child: const Text("Rebalancear Times", style: TextStyle(color: X5Colors.textSecondary))
        ),
      ],
    );
  }

  Widget _buildWinButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      // CORREÇÃO: FontWeight.black -> FontWeight.w900
      child: Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildQueue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("PRÓXIMOS DA FILA", style: TextStyle(fontWeight: FontWeight.bold, color: X5Colors.textSecondary)),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildQueueCard("Time 3", "Soma: 1450"),
              _buildQueueCard("Time 4", "Soma: 1420"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQueueCard(String title, String subtitle) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: X5Colors.surface,
        borderRadius: BorderRadius.circular(16),
        // CORREÇÃO: BorderSide -> Border.all
        border: Border.all(color: X5Colors.cardBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: X5Colors.textSecondary)),
        ],
      ),
    );
  }
}