import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GroqService {
  final String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> sendMessage(String message) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    final model = dotenv.env['GROQ_MODEL'] ?? 'llama3-8b-8192';

    if (apiKey == null || apiKey.isEmpty || apiKey == 'PASTE_YOUR_GROQ_API_KEY_HERE') {
      return 'Mode démonstration : ajoutez votre GROQ_API_KEY dans le fichier .env pour activer le vrai ChatBot.';
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': 'Tu es un assistant utile. Réponds simplement et clairement en français.'},
            {'role': 'user', 'content': message}
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Erreur API : ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      return 'Erreur de connexion : $e';
    }
  }
}
