import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

// ignore: use_key_in_widget_constructors
class AssessmentPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  List<String> features = ["STR", "DEX", "INT", "CHA", "CON"];
  List<double> featureValues = [2000, 8000, 1500, 8500, 7500];
  List<double> avgValues = [3865, 5550, 7560, 1229, 7500];
  bool isSnackBarVisible = false;
  bool isTransparencyReversed = false;

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
    List<List<double>> data = [featureValues, avgValues];

    return Scaffold(
      appBar: AppBar(title: Text('Assessment Page'), actions: [
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: _showInfoDialog,
        ),
      ]),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
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
                      _toggleTransparency();
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
                      graphColors: _getGraphColors(),
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
          SizedBox(height: 20.0),
          _buildInventory(),
        ],
      ),
    );
  }

  Widget _buildInventory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Colors.grey[200],
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Inventory',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 53,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _showItemDetails(context, index);
              },
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Item $index',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _toggleTransparency() {
    setState(() {
      isTransparencyReversed = !isTransparencyReversed;
    });
  }

  List<Color> _getGraphColors() {
    return isSnackBarVisible
        ? [Color(0x502A5034), Color(0xFF3399FF)]
        : [Color(0xFF2A5034), Color(0x503399FF)];
  }

  void _showSnackBar() {
    setState(() {
      isSnackBarVisible = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF2A5034),
          content: Align(
            alignment: Alignment.center,
            child: Text(
              _getSnackBarText(),
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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  String _getSnackBarText() {
    String snackBarText = "Armed Forces Average Status\n\n";
    for (int i = 0; i < features.length; i++) {
      snackBarText +=
          "${features[i]}      ·····      ${avgValues[i].toStringAsFixed(0)}\n";
    }
    return snackBarText;
  }

  void _showItemDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Item $index'),
          content: Text('Details of Item $index'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Text(
            'STR : 체력\nDEX : 주특기\nINT : 전술\nCHA : 리더십\nCON : 훈련\n\n그래프를 누르면 유저 평균 능력치를 확인할 수 있습니다\n능력치는 미션이나 훈련, 아이템 착용을 통해 강화할 수 있습니다',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        );
      },
    );
  }
}
