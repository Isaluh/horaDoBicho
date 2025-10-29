import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet.dart';

class PetsService {
  final String baseUrl = 'https://seu-backend.com/api';

  Future<List<Pet>> listarPets(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/pets?userId=$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao listar pets');
    }
  }

  Future<Pet?> criarPet(Map<String, dynamic> dados) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pets'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Pet.fromJson(jsonDecode(response.body));
    } else {
      print('Erro ao criar pet: ${response.body}');
      throw Exception('Falha ao criar pet (${response.statusCode})');
    }
  }

  Future<Pet?> atualizarPet(Pet pet) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pets/${pet.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );

    if (response.statusCode == 200) {
      return Pet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao atualizar pet');
    }
  }

  Future<Pet?> getPet(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/pets/$id'));

    if (response.statusCode == 200) {
      return Pet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao obter dados do pet');
    }
  }

  Future<void> deletarPet(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pets/$id'));

    if (response.statusCode != 204) {
      throw Exception('Falha ao deletar pet');
    }
  }
}
