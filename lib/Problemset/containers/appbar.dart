import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leetcodeclone/Login_SignUp/login_signup.dart';
import 'package:leetcodeclone/Problemset/styles/styles.dart';
import 'package:leetcodeclone/Profile/ProfilePage.dart';

class HomeAppBar extends StatefulWidget {
  final Function(String) setItem;
  const HomeAppBar({required this.setItem, super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBar();
}

class _HomeAppBar extends State<HomeAppBar> {
  String selectedButton = "Problems";
  List<Map<String, String>> Images = [
    {"imageurl": "assets/images/userpng.png", "name": "Profile"},
    {"imageurl": "assets/images/list.png", "name": "Lists"},
    {"imageurl": "assets/images/progress.png", "name": "Progress"},
    {"imageurl": "assets/images/trophy.png", "name": "Contest"},
    {"imageurl": "assets/images/settings.png", "name": "Settings"},
    {"imageurl": "assets/images/help.png", "name": "Help"},
  ];

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 1.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.purple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      toolbarHeight: 50,
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 200),
            Image.asset(
              "assets/images/logo.png",
              width: 40,
            ),
            const SizedBox(
              width: 30,
            ),
            for (String buttonText in [
              "Problems",
              "Contest",
              "Discuss",
              "Interview",
            ])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedButton = buttonText;
                      widget.setItem(buttonText);
                    });
                  },
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Text(buttonText,
                          style: TextStyle(
                            fontSize: 15,
                            color: buttonText == selectedButton
                                ? const Color.fromARGB(255, 209, 82, 124)
                                : Colors.white,
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 50,
                        height: 8,
                        color: buttonText == selectedButton
                            ? Colors.pink
                            : Colors.transparent,
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        _buildAccountDropdown(context),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.pink,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.bolt,
            color: Colors.pink,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: buttonStyle2,
            onPressed: () {},
            child: const Text(
              "Premium",
              style: TextStyle(color: Colors.pink),
            ),
          ),
        ),
        const SizedBox(
          width: 200,
        )
      ],
    );
  }

  Widget _buildAccountDropdown(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return PopupMenuButton<String>(
      tooltip: "Profile Menu",
      offset: const Offset(0, 56),
      icon: Icon(Icons.account_circle, color: Colors.grey[700]),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          enabled: false,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            title: Text(user?.displayName ?? 'User',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        PopupMenuItem<String>(
          enabled: false,
          child: SizedBox(
            height: 180,
            width: 300,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                for (Map<String, String> image in Images)
                  _buildGridItem(image['imageurl']!, image['name']!)
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'sign_out',
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            leading: Icon(Icons.exit_to_app, color: Colors.grey[700]),
            title: const Text('Sign Out'),
          ),
        ),
      ],
      onSelected: (String value) async {
        if (value == 'sign_out') {
          logoutLogic(context);
        }
      },
    );
  }

  Widget _buildGridItem(String image, String label) {
    return InkWell(
      onTap: () {
        if (label == "Profile") {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LeetCodeProfile()));
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 40,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
