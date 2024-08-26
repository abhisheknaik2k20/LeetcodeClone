import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/java.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:competitivecodingarena/AWS/Call_Logic/compiler_call.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import '../providers.dart';

class Texteditor extends ConsumerStatefulWidget {
  final Problem problem;
  final TextEditingController textEditingController;

  const Texteditor({
    required this.problem,
    required this.textEditingController,
    super.key,
  });

  @override
  _TexteditorState createState() => _TexteditorState();
}

class _TexteditorState extends ConsumerState<Texteditor> {
  String selectedLanguage = 'python';
  late CodeController controller;

  @override
  void initState() {
    super.initState();
    controller = CodeController(
      language: python,
    );
  }

  void updateLanguage(String? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        selectedLanguage = newLanguage;
        controller.language = getLanguage(newLanguage);
      });
    }
  }

  getLanguage(String lang) {
    switch (lang) {
      case 'cpp':
        return cpp;
      case 'java':
        return java;
      case 'python':
      default:
        return python;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                ref.read(consoleProvider.state).state = "Running.....";
                Map<String, dynamic> result = await callCompiler(
                    context, selectedLanguage, controller.text);
                ref.read(consoleProvider.state).state =
                    result['body'].toString();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2CBB5D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, size: 18),
                  SizedBox(width: 4),
                  Text(
                    "Run",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            DropdownButton<String>(
              value: selectedLanguage,
              items: <String>['cpp', 'java', 'python'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: updateLanguage,
            ),
          ],
        ),
        SizedBox(
          width: 1000,
          child: CodeTheme(
            data: CodeThemeData(styles: monokaiSublimeTheme),
            child: SingleChildScrollView(
              child: CodeField(controller: controller),
            ),
          ),
        ),
      ],
    );
  }
}
