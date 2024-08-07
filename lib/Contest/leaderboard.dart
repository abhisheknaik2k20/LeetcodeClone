import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  final Size size;
  const Categories({
    required this.size,
    super.key,
  });

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  ScrollController scrollController = ScrollController();
  double counter = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final List<String> randomNames =
      List.generate(25, (index) => faker.internet.userName());
  final List<String> randommessages =
      List.generate(25, (index) => faker.lorem.sentence());

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        counter = (counter + 50) % 800;
        scrollController.animateTo(counter,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: widget.size.height * 0.74,
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: 25,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Category(
                  title: randomNames[index],
                  numOfItems: index,
                  imageUrl: randommessages[index],
                  press: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String title;
  final int numOfItems;
  final VoidCallback press;
  final String? imageUrl;
  const Category({
    super.key,
    required this.title,
    required this.numOfItems,
    required this.press,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            "${numOfItems + 1}  ",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: numOfItems < 3 ? Colors.amber : Colors.white),
          ),
          const SizedBox(
            width: 10,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrls[numOfItems % 4]),
            radius: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                  text: "Rating: ",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 8,
                  ),
                ),
                TextSpan(
                  text: "3456",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 8,
                  ),
                )
              ]))
            ],
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

List<String> imageUrls = [
  "https://cdn-icons-png.flaticon.com/128/3135/3135715.png",
  "https://cdn-icons-png.flaticon.com/128/6997/6997662.png",
  "https://cdn-icons-png.flaticon.com/128/1999/1999625.png",
  "https://cdn-icons-png.flaticon.com/128/11498/11498793.png",
];
