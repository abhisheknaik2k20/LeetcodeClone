import 'package:competitivecodingarena/Core_Project/Community/map_screen.dart';
import 'package:competitivecodingarena/Core_Project/Community/search_screen.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreen();
}

class _CommunityScreen extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: height * 0.5,
                width: width * 0.4,
                child: MapScreen(),
              ),
              SizedBox(
                height: height * 0.5,
                width: width * 0.4,
                child: SearchScreen(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
