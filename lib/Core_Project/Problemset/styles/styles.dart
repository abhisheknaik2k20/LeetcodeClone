import 'package:flutter/material.dart';

// TextStyles
const TextStyle titleTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

const TextStyle subtitleTextStyle = TextStyle(
  fontSize: 10,
  color: Colors.grey,
);

const TextStyle labelTextStyle = TextStyle(
  fontSize: 10,
);

const TextStyle progressTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

// Decorations
BoxDecoration imageContainerDecoration(String imageUrl) => BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.fitHeight,
      ),
    );

BoxDecoration containerDecoration = BoxDecoration(
  color: Colors.white.withOpacity(0.1),
  borderRadius: const BorderRadius.all(Radius.circular(5)),
);

BoxDecoration calendarDecoration = BoxDecoration(
  color: Colors.white.withOpacity(0.1),
  borderRadius: const BorderRadius.all(Radius.circular(10)),
);

BoxDecoration ongoingPlanDecoration = BoxDecoration(
  color: Colors.pink.withOpacity(0.1),
  borderRadius: const BorderRadius.all(Radius.circular(10)),
  border: Border.all(color: Colors.white.withOpacity(0.2)),
);

// Icon Styles
IconData calendarIcon = Icons.calendar_today;
IconData progressIcon = Icons.trending_up;

// Button Styles
final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  backgroundColor: Colors.blue,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
);

final ButtonStyle buttonStyle2 = ElevatedButton.styleFrom(
  backgroundColor: Colors.pink.withOpacity(0.2),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
);
