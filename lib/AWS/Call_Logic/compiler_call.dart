import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:leetcodeclone/Snackbars&Pbars/snackbars.dart';

Future<Map<String, dynamic>> callCompiler(
    BuildContext context, String language, String code) async {
  showCircularbar(context);
  try {
    final response = await http.post(
      Uri.parse(dotenv.env['API']!),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"language": language, "code": code}),
    );
    Navigator.of(context).pop();
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}');
      return {
        'error': 'Request failed with status: ${response.statusCode}',
        'body': response.body,
      };
    }
  } catch (e) {
    Navigator.of(context).pop(); // Remove the circular progress indicator
    if (e is http.ClientException) {
      print('ClientException: ${e.message}');
      return {'error': 'ClientException: ${e.message}'};
    } else {
      print('Error: $e');
      return {'error': 'Error: $e'};
    }
  }
}
