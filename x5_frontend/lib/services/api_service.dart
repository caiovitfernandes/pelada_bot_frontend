import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player.dart';
import '../models/selection_player.dart';

class ApiService {
  // Mudamos para o seu backend local
  static const String baseUrl = 'http://localhost:3000/api';

  // 1. Autenticação do Admin
  Future<bool> authAdmin(String id, String pass) async {
  try {
    final resp = await http.post(
      Uri.parse('$baseUrl/autorizar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'peladaId': id, 'password': pass}),
    );
    
    if (resp.statusCode == 200) return true;
    
    print("Erro no Login: Status ${resp.statusCode} - ${resp.body}");
    return false;
  } catch (e) {
    print("Erro de conexão: $e");
    return false;
  }
}

  // 2. Busca a lista de jogadores
  Future<List<Player>> fetchPlayers(String peladaId) async {
    final response = await http.get(Uri.parse('$baseUrl/$peladaId/players'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => Player.fromJson(item)).toList();
    }
    throw Exception('Erro ao carregar jogadores');
  }

  // 3. Busca a seleção da última pelada
  Future<List<SelectionPlayer>> fetchLastSelection(String peladaId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$peladaId/selecao'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List decodedList = jsonDecode(data['SelecaoJSON'] ?? '[]');
        return decodedList.map((j) => SelectionPlayer.fromJson(j)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 4. Busca o estado atual do jogo (Time A, B e Fila)
  Future<Map<String, dynamic>?> fetchGameState(String peladaId) async {
    final response = await http.get(Uri.parse('$baseUrl/$peladaId/gamestate'));
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  // 5. Finaliza a partida e recebe o novo estado processado pelo Back-end
  Future<Map<String, dynamic>> finishMatch(String peladaId, String winner) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$peladaId/match/finish'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'winner': winner}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao processar vitória no servidor');
    }
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