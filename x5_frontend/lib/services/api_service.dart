import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player.dart';
import '../models/selection_player.dart';

class ApiService {
  static const String baseUrl = 'https://volei-bot-backend.azurewebsites.net/api';

  Future<List<Player>> fetchPlayers(String peladaId) async {
    final response = await http.get(Uri.parse('$baseUrl/$peladaId/players'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => Player.fromJson(item)).toList();
    }
    throw Exception('Erro ao carregar jogadores');
  }

  Future<bool> authAdmin(String id, String pass) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/autorizar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'peladaId': id, 'password': pass}),
    );
    return resp.statusCode == 200;
  }

  Future<List<SelectionPlayer>> fetchLastSelection(String peladaId) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/$peladaId/selecao'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // O seu backend retorna um campo SelecaoJSON que é uma string stringificada
      List selectionData = jsonDecode(data['SelecaoJSON'] ?? '[]');
      return selectionData.map((item) => SelectionPlayer.fromJson(item)).toList();
    }
    return []; // Se der 404 ou erro, retorna lista vazia (pelada ainda não encerrada)
  } catch (e) {
    return [];
  }
}
}