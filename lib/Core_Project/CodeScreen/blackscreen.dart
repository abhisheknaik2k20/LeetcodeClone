import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leetcodeclone/Core_Project/CodeScreen/dragcontain.dart';
import 'package:leetcodeclone/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class BlackScreen extends StatefulWidget {
  final String? teamid;
  final Problem problem;
  final Size size;
  final bool isOnline;
  const BlackScreen(
      {required this.teamid,
      required this.isOnline,
      required this.problem,
      required this.size,
      super.key});

  @override
  State<BlackScreen> createState() => _BlackScreenState();
}

class _BlackScreenState extends State<BlackScreen> {
  List<Widget> containers = [];
  List<Map<String, dynamic>> availableContainers = [
    {'name': 'Description', 'icon': Icons.description, 'color': Colors.red},
    {'name': 'Code', 'icon': Icons.code, 'color': Colors.blue},
    {'name': 'Solutions', 'icon': Icons.lightbulb, 'color': Colors.yellow},
    {'name': 'TestCases', 'icon': Icons.check_box, 'color': Colors.green},
    {'name': 'Console', 'icon': Icons.check_box, 'color': Colors.indigo},
  ];

  List<Map<String, dynamic>> onlineContainers = [
    {'name': 'Description', 'icon': Icons.description, 'color': Colors.red},
    {'name': 'OnlineCode', 'icon': Icons.code, 'color': Colors.blue},
    {'name': 'Solutions', 'icon': Icons.lightbulb, 'color': Colors.yellow},
    {'name': 'TestCases', 'icon': Icons.check_box, 'color': Colors.green},
    {'name': 'Console', 'icon': Icons.check_box, 'color': Colors.indigo},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isOnline) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          widget.isOnline
              ? SizedBox(
                  height: 200,
                  child: ZegoUIKitPrebuiltCall(
                      appID: 981366997,
                      appSign:
                          "d187b5964b1a88237199e6e5ceba8b58060e168f5de06c56e2ab43d29086a90a",
                      callID: widget.teamid!,
                      userID: FirebaseAuth.instance.currentUser!.uid,
                      userName: FirebaseAuth.instance.currentUser!.displayName!,
                      config: ZegoUIKitPrebuiltCallConfig.groupVoiceCall()))
              : Container(),
          SizedBox(
            height: widget.size.height,
            width: widget.size.width,
            child: Stack(
              children: [
                ...containers,
                Positioned(
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 50,
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: widget.isOnline
                            ? onlineContainers
                                .map((container) => TextButton.icon(
                                      onPressed: () => _addContainer(
                                          widget.problem,
                                          container['name'],
                                          container['icon'],
                                          container['color']),
                                      icon: Icon(container['icon'],
                                          color: container['color']),
                                      label: Text(
                                        container['name'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ))
                                .toList()
                            : availableContainers
                                .map((container) => TextButton.icon(
                                      onPressed: () => _addContainer(
                                          widget.problem,
                                          container['name'],
                                          container['icon'],
                                          container['color']),
                                      icon: Icon(container['icon'],
                                          color: container['color']),
                                      label: Text(
                                        container['name'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ))
                                .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addContainer(
      Problem problem, String name, IconData icon, MaterialColor color) {
    setState(() {
      containers.add(
        DraggableResizableContainer(
          teamid: widget.isOnline ? widget.teamid : null,
          problem: problem,
          color: color,
          icon: icon,
          key: Key('container_$name'),
          initialPosition: Offset(20.0 * (containers.length + 1), 70.0),
          initialSize: Size(widget.size.width * 0.3, widget.size.height * 0.3),
          minSize: const Size(100, 100),
          maxSize: Size(widget.size.width * 0.9, widget.size.height * 0.9),
          onRemove: _removeContainer,
          label: name,
          returnToButtonBar: _returnToButtonBar,
          bringToFront: _bringContainerToFront,
        ),
      );
      widget.isOnline
          ? onlineContainers
              .removeWhere((container) => container['name'] == name)
          : availableContainers
              .removeWhere((container) => container['name'] == name);
    });
  }

  void _removeContainer(Key key) {
    setState(() {
      containers.removeWhere((container) => container.key == key);
    });
  }

  void _returnToButtonBar(String name, IconData icon, MaterialColor color) {
    setState(() {
      containers
          .removeWhere((container) => container.key == Key('container_$name'));
      if (!availableContainers.any((container) => container['name'] == name)) {
        availableContainers.add({'name': name, 'icon': icon, 'color': color});
      }
      if (!onlineContainers.any((container) => container['name'] == name)) {
        onlineContainers.add({'name': name, 'icon': icon, 'color': color});
      }
    });
  }

  void _bringContainerToFront(Key key) {
    setState(() {
      int index = containers.indexWhere((container) => container.key == key);
      if (index != -1) {
        Widget container = containers.removeAt(index);
        containers.add(container);
      }
    });
  }
}
