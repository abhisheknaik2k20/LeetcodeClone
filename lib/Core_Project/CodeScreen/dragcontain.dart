import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leetcodeclone/Core_Project/CodeScreen/Containers/console.dart';
import 'package:leetcodeclone/Core_Project/CodeScreen/Containers/description.dart';
import 'package:leetcodeclone/Core_Project/CodeScreen/Containers/submission.dart';
import 'package:leetcodeclone/Core_Project/CodeScreen/Containers/testcase.dart';
import 'package:leetcodeclone/Core_Project/CodeScreen/Containers/texteditor.dart';
import 'package:leetcodeclone/Core_Project/Problemset/examples/exampleprobs.dart';

class DraggableResizableContainer extends StatefulWidget {
  final Problem problem;
  final Offset initialPosition;
  final Size initialSize;
  final IconData icon;
  final Size minSize;
  final MaterialColor color;
  final Size maxSize;
  final Function(Key) onRemove;
  final String label;
  final Function(String, IconData, MaterialColor) returnToButtonBar;
  final Function(Key) bringToFront;

  const DraggableResizableContainer({
    required this.problem,
    required this.color,
    required this.icon,
    required Key key,
    required this.initialPosition,
    required this.initialSize,
    required this.minSize,
    required this.maxSize,
    required this.onRemove,
    required this.label,
    required this.returnToButtonBar,
    required this.bringToFront,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DraggableResizableContainerState createState() =>
      _DraggableResizableContainerState();
}

class _DraggableResizableContainerState
    extends State<DraggableResizableContainer>
    with SingleTickerProviderStateMixin {
  late Offset position;
  late Size size;
  late ScrollController sc;
  final double barHeight = 40.0;
  final tc = TextEditingController();
  String result = "";
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    sc = ScrollController();
    position = widget.initialPosition;
    size = widget.initialSize;
    tc.text =
        'class Solution{\n\t\t\tpublic static void main(String[] args){\n\t\t\t}\n}';
    result = "Run the code First";
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    sc.dispose();
    tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: () => widget.bringToFront(widget.key!),
        onPanUpdate: (details) {
          setState(() {
            position = Offset(
              position.dx + details.delta.dx,
              position.dy + details.delta.dy,
            );
          });
        },
        onPanEnd: (details) {
          if (position.dy < 50) {
            widget.returnToButtonBar(widget.label, widget.icon, widget.color);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          width: size.width,
          height: size.height + barHeight,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: barHeight,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: widget.color.shade800,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8)),
              child: CupertinoScrollbar(
                thumbVisibility: true,
                thickness: 6,
                controller: sc,
                child: SingleChildScrollView(
                  controller: sc,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(15),
                  child: _buildContentByLabel(),
                ),
              ),
            ),
          ),
          if (widget.label == 'Description') _buildDescriptionFooter(),
          _buildResizeHandle(),
        ],
      ),
    );
  }

  Widget _buildContentByLabel() {
    switch (widget.label) {
      case 'Description':
        return problemToRichText(widget.problem);
      case 'Code':
        return Texteditor(
          textEditingController: tc,
          problem: widget.problem,
        );
      case 'TestCases':
        return Testcase(problem: widget.problem);
      case 'Solutions':
        return const Submissions();
      case 'Console':
        return const Console();
      default:
        return const Text('Unknown', style: TextStyle(color: Colors.white));
    }
  }

  Widget _buildDescriptionFooter() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: widget.color.shade800,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_alt_outlined,
                      color: Colors.white),
                  onPressed: () {},
                ),
                const Text('1.9K', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 15),
                IconButton(
                  icon: const Icon(Icons.thumb_down_alt_outlined,
                      color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.comment_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.star_outline, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResizeHandle() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            size = Size(
              (size.width + details.delta.dx)
                  .clamp(widget.minSize.width, widget.maxSize.width),
              (size.height + details.delta.dy)
                  .clamp(widget.minSize.height, widget.maxSize.height),
            );
          });
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeDownRight,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomRight: Radius.circular(8),
              ),
            ),
            child:
                const Icon(Icons.drag_handle, size: 15, color: Colors.white54),
          ),
        ),
      ),
    );
  }
}
