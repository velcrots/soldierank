import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class AssessmentPage extends StatefulWidget {
  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  // Define feature values
  List<String> features = ["STR", "DEX", "INT", "CHA", "CON"];
  List<double> featureValues = [2000, 8000, 1500, 8500, 7500];
  List<double> avgValues = [3865, 5550, 7560, 1229, 7500];
  bool isSnackBarVisible = false;
  bool isTransparencyReversed = false;

  // Function to determine text color based on featureValue and avgValue
  Color determineTextColor(int index) {
    if (featureValues[index] < avgValues[index]) {
      return Colors.red;
    } else if (featureValues[index] > avgValues[index]) {
      return Color.fromARGB(255, 0, 27, 105); // #001B69
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define the values for the radar chart
    List<List<double>> data = [featureValues, avgValues];

    return Scaffold(
      appBar: AppBar(
        title: Text('Combat Power Management Page'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                padding: const EdgeInsets.all(20.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GestureDetector(
                    onLongPressStart: (_) {
                      setState(() {
                        isTransparencyReversed = !isTransparencyReversed;
                      });
                      _showSnackBar();
                    },
                    onLongPressEnd: (_) {
                      _hideSnackBar();
                    },
                    child: RadarChart(
                      key: ValueKey(isTransparencyReversed),
                      features: features,
                      data: data,
                      ticks: const [2000, 4000, 6000, 8000, 10000],
                      axisColor: Colors.green,
                      outlineColor: Color.fromARGB(255, 42, 80, 52),
                      sides: 5,
                      ticksTextStyle: TextStyle(
                          fontSize: 10, color: Colors.amber.withOpacity(0)),
                      graphColors: isSnackBarVisible
                          ? [
                              Color(0x502A5034), // 20% opacity
                              Color(0xFF3399FF) // 100% opacity
                            ]
                          : [
                              Color(0xFF2A5034), // 100% opacity
                              Color(0x503399FF) // 20% opacity
                            ],
                      featuresTextStyle: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < features.length; i++)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  features[i],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: determineTextColor(i)),
                                ),
                                Expanded(
                                  child: Text(
                                    '${featureValues[i].toInt()}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: determineTextColor(i),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Middle part
          Expanded(
            child: Center(
              child: Text(
                'Middle part text',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Bottom part
          Expanded(
            child: Center(
              child: Text(
                'Bottom part text',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar() {
    setState(() {
      isSnackBarVisible = true;
      if (isTransparencyReversed) {
        isTransparencyReversed = false;
      }
      String snackBarText = "Armed Forces Average Status\n\n";
      for (int i = 0; i < features.length; i++) {
        snackBarText +=
            "${features[i]}      ·····      ${avgValues[i].toStringAsFixed(0)}\n";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF2A5034),
          content: Align(
            alignment: Alignment.center,
            child: Text(
              snackBarText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _hideSnackBar() {
    setState(() {
      isSnackBarVisible = false;
      if (!isTransparencyReversed) {
        isTransparencyReversed = true;
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: AssessmentPage(),
  ));
}
