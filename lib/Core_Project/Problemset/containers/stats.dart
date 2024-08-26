import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/comapnies.dart';

class PersonalStats extends StatefulWidget {
  const PersonalStats({super.key});

  @override
  State<PersonalStats> createState() => _PersonalStatsState();
}

class _PersonalStatsState extends State<PersonalStats> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          EasyPieChart(
              style: const TextStyle(fontSize: 10, color: Colors.white),
              size: 100,
              borderEdge: StrokeCap.butt,
              start: -180,
              children: [
                PieData(value: 20, color: Colors.teal),
                PieData(value: 5, color: Colors.amber),
                PieData(value: 5, color: Colors.pink),
                PieData(value: 70, color: Colors.white.withOpacity(0.1)),
              ]),
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (Map<String, dynamic> diff in difficulty)
                  Row(
                    children: [
                      Text(
                        diff['difficulty'],
                        style: TextStyle(color: diff['color']),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        diff['solved'],
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                      Text(
                        '/56',
                        style: TextStyle(color: Colors.white.withOpacity(0.2)),
                      )
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
