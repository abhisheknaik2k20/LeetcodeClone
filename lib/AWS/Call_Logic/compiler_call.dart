import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:competitivecodingarena/Snackbars&Pbars/snackbars.dart';

Future<Map<String, dynamic>> callCompiler(
    BuildContext context, String language, String code) async {
  showCircularbar(context);
  try {
    final response = await http.post(
      Uri.parse(),
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
    Navigator.of(context).pop();
    if (e is http.ClientException) {
      print('ClientException: ${e.message}');
      return {'error': 'ClientException: ${e.message}'};
    } else {
      print('Error: $e');
      return {'error': 'Error: $e'};
    }
  }
}

Future<Map<String, dynamic>> invokeLambdaFunction({
  required String userId,
  required String reason,
  required String skillLevel,
  required List<String> topics,
  required List<String> journey,
}) async {
  try {
    const url =
    if (url.isEmpty) {
      throw Exception('Recommender URL is not set in environment variables');
    }

    print("Request made to: $url");
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_data': {
          'user_id': userId,
          'topics': topics,
          'journey': journey,
        },
        'reason': reason,
        'skillLevel': skillLevel,
      }),
    );

    //print("Response status: ${response.statusCode}");
    //print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      return {
        'error': 'Failed to invoke Lambda function',
        'status': response.statusCode,
        'body': response.body,
      };
    }
  } catch (e) {
    print("Error in invokeLambdaFunction: $e");
    return {
      'error': 'Error invoking Lambda function',
      'details': e.toString(),
    };
  }
}
