import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:leetcodeclone/Core_Project/CodeScreen/blackscreen.dart';
import 'package:leetcodeclone/Core_Project/Problemset/containers/companies.dart';
import 'package:leetcodeclone/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:leetcodeclone/Core_Project/Problemset/containers/stats.dart';
import 'package:leetcodeclone/Snackbars&Pbars/snackbars.dart';

class ProblemsetMenu extends StatefulWidget {
  final Size size;
  const ProblemsetMenu({required this.size, super.key});

  @override
  _ProblemsetMenuState createState() => _ProblemsetMenuState();
}

class _ProblemsetMenuState extends State<ProblemsetMenu> {
  List<Problem> problems = [];
  List<Problem> filteredProblems = [];
  String searchQuery = "";
  String difficultyFilter = "All";
  String statusFilter = "All";
  String frequencyFilter = "All";

  @override
  void initState() {
    super.initState();
    fetchProblemsFromFirestore();
  }

  Future<void> fetchProblemsFromFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference problemsCollection =
        firestore.collection('problems');

    try {
      QuerySnapshot querySnapshot = await problemsCollection.get();
      problems =
          querySnapshot.docs.map((doc) => Problem.fromFirestore(doc)).toList();
      setState(() {
        filteredProblems = problems;
      });
    } on FirebaseException catch (e) {
      showSnackBar(context, e.code);
    }
  }

  void filterProblems() {
    setState(() {
      filteredProblems = problems.where((problem) {
        bool matchesSearch =
            problem.title.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesDifficulty =
            difficultyFilter == "All" || problem.difficulty == difficultyFilter;
        bool matchesStatus =
            statusFilter == "All" || problem.status == statusFilter;
        bool matchesFrequency =
            frequencyFilter == "All" || problem.frequency == frequencyFilter;
        return matchesSearch &&
            matchesDifficulty &&
            matchesStatus &&
            matchesFrequency;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: widget.size.width * 0.127),
        SizedBox(
          height: 550,
          width: widget.size.width * 0.5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    onChanged: (value) {
                      searchQuery = value;
                      filterProblems();
                    },
                    cursorHeight: 15.0,
                    style: const TextStyle(fontSize: 10),
                    decoration: const InputDecoration(
                      labelText: "Search",
                      labelStyle:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 10,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Difficulty',
                        style: TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 35,
                        child: buildDropdownFilter(
                            "Difficulty",
                            ["All", "Easy", "Medium", "Hard"],
                            difficultyFilter, (value) {
                          setState(() {
                            difficultyFilter = value!;
                            filterProblems();
                          });
                        }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 35,
                        child: buildDropdownFilter(
                            "Status",
                            ["All", "Solved", "Attempted", "Todo"],
                            statusFilter, (value) {
                          setState(() {
                            statusFilter = value!;
                            filterProblems();
                          });
                        }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Frequency',
                        style: TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 35,
                        child: buildDropdownFilter(
                            "Frequency",
                            ["All", "High", "Medium", "Low"],
                            frequencyFilter, (value) {
                          setState(() {
                            frequencyFilter = value!;
                            filterProblems();
                          });
                        }),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredProblems.length,
                  itemBuilder: (context, index) {
                    Problem problem = filteredProblems[index];
                    return ListTile(
                      minTileHeight: 20,
                      tileColor: index % 2 != 0
                          ? Colors.white.withOpacity(0.05)
                          : Colors.transparent,
                      title: Text(
                        problem.title,
                        style: const TextStyle(fontSize: 10),
                      ),
                      subtitle: Text(
                        "Acceptance: ${problem.acceptanceRate.toStringAsFixed(1)}%",
                        style: const TextStyle(fontSize: 10),
                      ),
                      trailing: Text(
                        problem.difficulty,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: problem.difficulty == 'Easy'
                                ? Colors.teal
                                : problem.difficulty == 'Medium'
                                    ? Colors.amber
                                    : Colors.pink),
                      ),
                      leading: Icon(
                        size: 15,
                        problem.status == "Solved"
                            ? Icons.circle
                            : problem.status == 'Attempted'
                                ? Icons.circle
                                : Icons.circle_outlined,
                        color: problem.status == "Solved"
                            ? Colors.green
                            : problem.status == 'Attempted'
                                ? Colors.amber
                                : Colors.grey,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlackScreen(
                              problem: problem,
                              size: MediaQuery.sizeOf(context),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.all(5),
          height: 600,
          width: widget.size.width * 0.199,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Companies(), PersonalStats()],
          ),
        )
      ],
    );
  }

  Widget buildDropdownFilter(String label, List<String> items,
      String currentValue, void Function(String?) onChanged) {
    return DropdownButton<String>(
      value: currentValue,
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 10),
          ),
        );
      }).toList(),
      hint: Text(
        label,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}
