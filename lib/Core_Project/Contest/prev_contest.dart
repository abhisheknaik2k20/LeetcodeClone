import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastContestsMenu extends StatefulWidget {
  final Size size;
  const PastContestsMenu({required this.size, super.key});

  @override
  State<PastContestsMenu> createState() => _PastContestsMenuState();
}

class _PastContestsMenuState extends State<PastContestsMenu> {
  int selectednum = 1;
  final sc = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.height * 0.8,
      child: Column(
        children: [
          SizedBox(
            height: widget.size.height * 0.76,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: sc,
              itemCount: pastContests.length,
              itemBuilder: (context, index) {
                return ContestCard(contest: pastContests[index]);
              },
            ),
          ),
          SizedBox(
            height: widget.size.height * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (int i = 1; i <= 4; i++)
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
          contest.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
        subtitle: Text(
          DateFormat('MMMM d, yyyy').format(contest.date),
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

class Contest {
  final String name;
  final DateTime date;

  Contest({required this.name, required this.date});
}

List<Contest> pastContests = [
  Contest(name: 'Weekly Contest 292', date: DateTime(2022, 5, 8)),
  Contest(name: 'Biweekly Contest 78', date: DateTime(2022, 5, 14)),
  Contest(name: 'Weekly Contest 293', date: DateTime(2022, 5, 15)),
  Contest(name: 'Weekly Contest 292', date: DateTime(2022, 5, 8)),
  Contest(name: 'Biweekly Contest 78', date: DateTime(2022, 5, 14)),
  Contest(name: 'Weekly Contest 293', date: DateTime(2022, 5, 15)),
  Contest(name: 'Weekly Contest 292', date: DateTime(2022, 5, 8)),
  Contest(name: 'Biweekly Contest 78', date: DateTime(2022, 5, 14)),
  Contest(name: 'Weekly Contest 293', date: DateTime(2022, 5, 15)),
  Contest(name: 'Biweekly Contest 78', date: DateTime(2022, 5, 14)),
  Contest(name: 'Weekly Contest 293', date: DateTime(2022, 5, 15)),
  Contest(name: 'Weekly Contest 292', date: DateTime(2022, 5, 8)),
  Contest(name: 'Biweekly Contest 78', date: DateTime(2022, 5, 14)),
  Contest(name: 'Weekly Contest 293', date: DateTime(2022, 5, 15)),
  Contest(name: 'Biweekly Contest 78', date: DateTime(2022, 5, 14)),
  Contest(name: 'Weekly Contest 293', date: DateTime(2022, 5, 15)),
  Contest(name: 'Weekly Contest 292', date: DateTime(2022, 5, 8)),
  Contest(name: 'Biweekly Contest 78', date: DateTime(2022, 5, 14)),
  Contest(name: 'Weekly Contest 293', date: DateTime(2022, 5, 15)),
  Contest(name: 'Biweekly Contest 78', date: DateTime(2022, 5, 14)),
  Contest(name: 'Weekly Contest 293', date: DateTime(2022, 5, 15)),
  Contest(name: 'Weekly Contest 292', date: DateTime(2022, 5, 8)),
  Contest(name: 'Biweekly Contest 78', date: DateTime(2022, 5, 14)),
  Contest(name: 'Weekly Contest 293', date: DateTime(2022, 5, 15)),
];
