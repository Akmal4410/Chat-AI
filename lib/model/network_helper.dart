import 'dart:convert';

import 'package:chat_ai/api_key.dart';
import 'package:http/http.dart' as http;

class NetWorkHelper {
  Future<String> getResponse(String query) async {
    const apikey = apiSecretKey;
    var url = Uri.https("api.openai.com", "/v1/completions");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apikey",
    };

    final body = jsonEncode({
      "model": "text-davinci-003",
      "prompt": query,
      "temperature": 0,
      "max_tokens": 2000,
      "top_p": 1,
      "frequency_penalty": 0.0,
      "presence_penalty": 0.0
    });

    final response = await http.post(url, headers: headers, body: body);

    // Decode the response
    Map<String, dynamic> newResponse = jsonDecode(response.body);
    return newResponse['choices'][0]['text'];
  }
}
