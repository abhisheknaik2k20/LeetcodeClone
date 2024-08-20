import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';
import 'package:leetcodeclone/AWS/Call_Logic/compiler_call.dart';

class OnlineCodeEditor extends StatefulWidget {
  final String? teamid;
  const OnlineCodeEditor({required this.teamid, super.key});

  @override
  State<OnlineCodeEditor> createState() => _OnlineCodeEditorState();
}

class _OnlineCodeEditorState extends State<OnlineCodeEditor> {
  late CodeController _codeController;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;
  bool isLocalChange = false;

  String selectedLanguage = 'python';

  Map<String, Mode> language = {"python": python, "java": java, "cpp": cpp};

  void updateLanguage(String? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        selectedLanguage = newLanguage;
        _codeController.language = getLanguage(newLanguage);
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
  void initState() {
    super.initState();
    uid = auth.currentUser?.uid ?? '';
    _codeController = CodeController(language: java, modifiers: const [
      CloseBlockModifier(),
      TabModifier(),
      IndentModifier()
    ]);
    _updateFirestore();
  }

  Future<void> _updateFirestore() async {
    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("UID is empty, cannot update Firestore")),
      );
      return;
    }
    try {
      await firestore.collection('code').doc(widget.teamid).set({
        'uid': uid,
        'data': _codeController.text,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $error')),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    auth.currentUser?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('code').doc(widget.teamid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No data available'));
        }
        Map<String, dynamic>? data =
            snapshot.data!.data() as Map<String, dynamic>?;
        String documentUid = data?['uid'] as String? ?? '';
        String codeText = data?['data'] as String? ?? '';
        if (uid != documentUid && _codeController.text != codeText) {
          isLocalChange = false;
          _codeController.text = codeText;
          isLocalChange = true;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CodeTheme(
                data: CodeThemeData(styles: monokaiSublimeTheme),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await callCompiler(context, selectedLanguage,
                                    _codeController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2CBB5D),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.play_arrow, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    "Run",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            DropdownButton<String>(
                              value: selectedLanguage,
                              items: <String>['cpp', 'java', 'python']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: updateLanguage,
                            ),
                          ],
                        ),
                      ),
                      CodeField(
                        controller: _codeController,
                        textStyle: const TextStyle(
                            fontFamily: 'monospace', fontSize: 14),
                        onChanged: (_) {
                          _updateFirestore();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
