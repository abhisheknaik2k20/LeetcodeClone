import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:leetcodeclone/ImageScr/homeScreen.dart';
import '../styles/styles.dart';

class AdsAndCalender extends StatefulWidget {
  final Size size;
  const AdsAndCalender({required this.size, super.key});

  @override
  State<AdsAndCalender> createState() => _AdsAndCalenderState();
}

class _AdsAndCalenderState extends State<AdsAndCalender> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: widget.size.width * 0.13),
        SizedBox(
          width: widget.size.width * 0.5,
          height: 470,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageRow(
                  widget.size.width * 0.15, widget.size.height * 0.17, imagscr),
              const SizedBox(height: 25),
              const Text("Study Plan", style: titleTextStyle),
              const SizedBox(height: 5),
              _buildInfoRow(widget.size.width * 0.15, widget.size.height * 0.13,
                  imagscr2, text1),
              const SizedBox(height: 10),
              _buildInfoRow(widget.size.width * 0.15, widget.size.height * 0.13,
                  imgscr3, text2),
              const SizedBox(height: 20),
              const Text("Topics to Explore", style: TextStyle(fontSize: 15)),
              const SizedBox(height: 5),
              _buildTopicsRow(widget.size.width * 0.49),
            ],
          ),
        ),
        _buildCalendarColumn(widget.size.width * 0.2, 470),
        SizedBox(width: widget.size.width * 0.1),
      ],
    );
  }

  Widget _buildImageRow(double width, double height, List<String> imageUrls) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (String imageUrl in imageUrls)
          Container(
            clipBehavior: Clip.antiAlias,
            width: width,
            height: height,
            decoration: imageContainerDecoration(imageUrl),
          ),
      ],
    );
  }

  Widget _buildInfoRow(double width, double height, List<String> imageUrls,
      List<Map<String, String>> texts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (int i = 0; i < imageUrls.length; i++)
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            width: width,
            height: height,
            decoration: containerDecoration,
            child: Row(
              children: [
                Image.network(imageUrls[i]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("  ${texts[i]['title']!}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Text("   ${texts[i]['subtitle']!}",
                        style: subtitleTextStyle),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTopicsRow(double width) {
    return Row(
      children: [
        SizedBox(
          width: width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (Map<String, dynamic> name in namesofcol)
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: Row(
                        children: [
                          Icon(name['icon'], color: name['color'], size: 15),
                          const SizedBox(width: 5),
                          Text(name['title'], style: labelTextStyle),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarColumn(double width, double height) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: calendarDecoration,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Day ${DateTime.now().day}",
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 300,
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarViewScrollPhysics:
                      const NeverScrollableScrollPhysics(),
                  controlsHeight: 0,
                  lastMonthIcon: const Icon(Icons.abc, size: 0),
                  nextMonthIcon: const Icon(Icons.abc, size: 0),
                  disableMonthPicker: true,
                  disableModePicker: true,
                  selectedDayHighlightColor: Colors.pink,
                  selectedDayTextStyle: const TextStyle(color: Colors.white),
                ),
                value: const [],
              ),
            ),
          ),
          _buildOngoingPlanContainer(widget.size.width * 0.19, 135),
        ],
      ),
    );
  }

  Widget _buildOngoingPlanContainer(double width, double height) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: width,
      height: height,
      decoration: ongoingPlanDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ongoing Study Plan", style: progressTextStyle),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.network(imagscr2[2], width: 80),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Plan Name'),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          value: 0.1,
                          color: Colors.white.withOpacity(0.1),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.pink),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text('10%',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 10)),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Continue?",
                      style:
                          TextStyle(fontSize: 10, color: Colors.blue.shade600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
