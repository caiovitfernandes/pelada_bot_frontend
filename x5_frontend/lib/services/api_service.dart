import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player.dart';
import '../models/selection_player.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<bool> authAdmin(String id, String pass) async {
    try {
      final resp = await http.post(Uri.parse('$baseUrl/autorizar'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'peladaId': id, 'password': pass}));
      return resp.statusCode == 200;
    } catch (e) { return false; }
  }

  Future<List<Player>> fetchPlayers(String peladaId) async {
    final resp = await http.get(Uri.parse('$baseUrl/$peladaId/players'));
    if (resp.statusCode == 200) {
      List data = jsonDecode(resp.body);
      return data.map((item) => Player.fromJson(item)).toList();
    }
    throw Exception('Erro ao carregar jogadores');
  }

  Future<List<SelectionPlayer>> fetchLastSelection(String peladaId) async {
    try {
      final resp = await http.get(Uri.parse('$baseUrl/$peladaId/selecao'));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final List decoded = jsonDecode(data['SelecaoJSON'] ?? '[]');
        return decoded.map((j) => SelectionPlayer.fromJson(j)).toList();
      }
      return [];
    } catch (e) { return []; }
  }

  Future<Map<String, dynamic>?> fetchGameState(String peladaId) async {
    final resp = await http.get(Uri.parse('$baseUrl/$peladaId/gamestate'));
    if (resp.statusCode == 200) return jsonDecode(resp.body);
    return null;
  }

  Future<Map<String, dynamic>> finishMatch(String peladaId, String winner) async {
    final resp = await http.post(Uri.parse('$baseUrl/$peladaId/match/finish'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'winner': winner}));
    if (resp.statusCode == 200) return jsonDecode(resp.body);
    throw Exception('Erro ao processar vitória');
  }

  Future<void> deleteGameState(String peladaId) async {
    final resp = await http.delete(Uri.parse('$baseUrl/$peladaId/gamestate'));
    if (resp.statusCode != 200) throw Exception('Erro ao encerrar');
  }

  Future<void> addPlayer(String peladaId, String nome) async {
    await http.post(Uri.parse('$baseUrl/$peladaId/players'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode({'nome': nome}));
  }

  Future<void> deletePlayer(String peladaId, String nome) async {
    await http.delete(Uri.parse('$baseUrl/$peladaId/players/$nome'));
  }

  Future<void> initializeMatch(String peladaId, List<String> jogadores, int tamanho) async {
    await http.post(Uri.parse('$baseUrl/$peladaId/match/initialize'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'jogadoresSelecionados': jogadores, 'tamanhoTime': tamanho}));
  }
}