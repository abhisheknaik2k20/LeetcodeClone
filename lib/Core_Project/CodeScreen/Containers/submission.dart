import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/Containers/graph.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';

class Submissions extends StatefulWidget {
  const Submissions({super.key});

  @override
  State<Submissions> createState() => _Submissions();
}

class _Submissions extends State<Submissions> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 20,
      ),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              width: 50,
            ),
            SubmissionGraphPage(),
          ]))
    ]);
  }
}

Future<void> writeProblemsToFirestore(List<Problem> problems) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference problemsCollection =
      firestore.collection('problems');

  for (var problem in problems) {
    try {
      await problemsCollection.doc(problem.id).set({
        'id': problem.id,
        'title': problem.title,
        'difficulty': problem.difficulty,
        'content': problem.content,
        'testcases': problem.testcases,
        'status': problem.status,
        'acceptanceRate': problem.acceptanceRate,
        'frequency': problem.frequency,
      });
      print('Successfully added problem: ${problem.title}');
    } catch (e) {
      print('Error adding problem ${problem.title}: $e');
    }
  }
}
