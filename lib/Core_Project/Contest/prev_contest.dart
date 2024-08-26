import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:competitivecodingarena/Core_Project/Contest/contestclass.dart';

class PastContestsMenu extends StatefulWidget {
  final Size size;
  const PastContestsMenu({required this.size, super.key});

  @override
  State<PastContestsMenu> createState() => _PastContestsMenuState();
}

class _PastContestsMenuState extends State<PastContestsMenu> {
  int selectednum = 1;
  late ScrollController sc;
  // ignore: unused_field
  bool _isLoading = true;

  List<Contest> contests = [];

  Future<List<Contest>> fetchContestsFromFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot =
        await firestore.collection('contests').orderBy('Contest_id').get();
    return snapshot.docs.map((doc) => Contest.fromFirestore(doc)).toList();
  }

  @override
  void initState() {
    super.initState();
    sc = ScrollController();
    generateList();
  }

  void generateList() async {
    try {
      List<Contest> fetchedContests = await fetchContestsFromFirestore();
      setState(() {
        contests = fetchedContests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    sc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int pagelength = (contests.length / 8).ceil();
    return SizedBox(
      height: widget.size.height * 0.8,
      child: Column(
        children: [
          SizedBox(
            height: widget.size.height * 0.76,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: sc,
              itemCount: contests.length,
              itemBuilder: (context, index) {
                return ContestCard(contest: contests[index]);
              },
            ),
          ),
          SizedBox(
            height: widget.size.height * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (int i = 1; i <= pagelength; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: i == selectednum
                            ? Colors.white.withOpacity(0.4)
                            : Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        minimumSize: const Size(25, 25),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        setState(() {
                          selectednum = i;
                        });
                        sc.jumpTo(widget.size.height * 0.76 * (i - 1));
                      },
                      child: Text(
                        i.toString(),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ContestCard extends StatelessWidget {
  final Contest contest;
  const ContestCard({super.key, required this.contest});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcpKizuouJPQa9RG-WfkaXejSVPrvvso57dA&s"),
        title: Text(
          contest.Contest_id.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
        subtitle: Text(
          DateFormat('MMMM d, yyyy').format(contest.start.toDate()),
          style: TextStyle(color: Colors.grey[600], fontSize: 10),
        ),
        trailing: Container(
          height: 25,
          width: 55,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Text(
              "Virtual",
              style: TextStyle(color: Colors.purple.shade400),
            ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
