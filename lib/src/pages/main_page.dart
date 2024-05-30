import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ace/src/components/image_data.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  final String userId;

  const MainPage(this.userId, {super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Timer _globalTimer;
  late Timer _vacationTimer;
  late Timer _egressionTimer;
  late DateFormat format;
  String soldierType = '';
  DateTime? joinDate;
  DateTime? dischargeDate;
  DateTime? preOutingDate;
  DateTime? nextVacationDate;
  DateTime? nextEgressionDate;
  int globalProgress = 0;
  int vacationProgress = 0;
  int egressionProgress = 0;
  double requireSecondGL = 0.0;
  double requireSecondNV = 0.0;
  double requireSecondNE = 0.0;

  @override
  void initState() {
    super.initState();
    format = DateFormat('yyyy-MM-dd HH:mm:ss');
    _fetchUserData();
  }

  @override
  void dispose() {
    _globalTimer.cancel();
    _vacationTimer.cancel();
    _egressionTimer.cancel();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final result = await _callAPI(widget.userId);
      setState(() {
        soldierType = result['사용자'][0]['군별'];
        joinDate = _parseDate(result['사용자'][0]['입대일'] ?? '');
        dischargeDate =
            _parseDate(result['사용자'][0]['전역일'] ?? '').add(Duration(days: 1));
        preOutingDate = _parseDate(result['사용자'][0]['최근_복귀일'] ?? '');
        nextVacationDate = _parseDate(result['휴가'][0]['출발_날짜'] ?? '');
        nextEgressionDate = _parseDate(result['외출'][0]['출발_날짜'] ?? '');

        if (joinDate != null && dischargeDate != null) {
          requireSecondGL =
              _calculateRequireSecond(joinDate!, dischargeDate!, 7);
        }

        if (preOutingDate != null && nextVacationDate != null) {
          requireSecondNV =
              _calculateRequireSecond(preOutingDate!, nextVacationDate!, 5);
        }

        if (preOutingDate != null && nextEgressionDate != null) {
          requireSecondNE =
              _calculateRequireSecond(preOutingDate!, nextEgressionDate!, 5);
        }
        _setInitProgress();
        _startTimers();
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<Map<String, dynamic>> _callAPI(String idText) async {
    final url = Uri.parse(
        'http://navy-combat-power-management-platform.shop/getInfo.php');
    final response = await Dio().postUri(url, data: {'username': idText});
    return response.data;
  }

  // TODO : 정확도 이슈 해결
  void _startTimers() {
    _startGlobalTimer();
    _startVacationTimer();
    _startEgressionTimer();
  }

  void _startGlobalTimer() async {
    await Future.delayed(
        Duration(microseconds: (requireSecondGL * 1000000).toInt()));
    _globalTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        globalProgress += 1;
      });
    });
  }

  void _startVacationTimer() async {
    await Future.delayed(
        Duration(microseconds: (requireSecondNV * 1000000).toInt()));
    _vacationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        vacationProgress += 1;
      });
    });
  }

  void _startEgressionTimer() async {
    await Future.delayed(
        Duration(microseconds: (requireSecondNE * 1000000).toInt()));
    _egressionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        egressionProgress += 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: (() {
                      switch (soldierType) {
                        case '육군':
                          return Image.asset(
                            AvatarPath.armyAvatar,
                            fit: BoxFit.contain,
                          );
                        case '해군':
                          return Image.asset(
                            AvatarPath.navyAvatar,
                            fit: BoxFit.contain,
                          );
                        case '공군':
                          return Image.asset(
                            AvatarPath.airForceAvatar,
                            fit: BoxFit.contain,
                          );
                        default:
                          return Container();
                      }
                    })(),
                  ),
                ),
              ),
            ),
            buildProgressBar(
              context,
              title: '전역',
              progress: globalProgress / 10000000,
              endDate: dischargeDate != null
                  ? DateFormat('yyyy-MM-dd').format(dischargeDate!)
                  : '',
              titleFontSize: 13,
              topDateFontSize: 12,
              bottomPercentFontSize: 12,
              fullWidth: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: buildProgressBars(
                context,
                vacationTitle: '다음 휴가',
                vacationProgress: vacationProgress / 100000,
                nextVacationDate: nextVacationDate != null
                    ? DateFormat('yyyy-MM-dd').format(nextVacationDate!)
                    : '-',
                egressionTitle: '다음 외출',
                egressionProgress: egressionProgress / 100000,
                nextEgressionDate: nextEgressionDate != null
                    ? DateFormat('yyyy-MM-dd').format(nextEgressionDate!)
                    : '-',
                titleFontSize: 12,
                topDateFontSize: 11,
                bottomPercentFontSize: 11,
                topPadding: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoRow(
                      '전체 복무일',
                      dischargeDate != null && joinDate != null
                          ? dischargeDate!
                              .difference(joinDate!)
                              .inDays
                              .toString()
                          : ''),
                  buildLine(),
                  buildInfoRow(
                      '현재 복무일',
                      dischargeDate != null && joinDate != null
                          ? DateTime.now()
                              .difference(joinDate!)
                              .inDays
                              .toString()
                          : ''),
                  buildLine(),
                  buildInfoRow(
                      '남은 복무일',
                      dischargeDate != null
                          ? dischargeDate!
                              .difference(DateTime.now())
                              .inDays
                              .toString()
                          : ''),
                  buildLine(),
                  buildInfoRow(
                      '다음 휴가까지',
                      nextVacationDate != null
                          ? nextVacationDate!
                              .difference(DateTime.now())
                              .inDays
                              .toString()
                          : '-')
                ],
              ),
            ),
            const Text(
              '※제공되는 정보는 법적 효력 및 행정 효력이 없습니다.\n\n\n',
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  DateTime _parseDate(String dateString) {
    List<String> components = dateString.split(' ');

    if (components.length == 1) {
      return DateFormat('yyyy-MM-dd').parse(dateString);
    } else {
      return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateString);
    }
  }

  int _calculateProgress(DateTime startDate, DateTime endDate, int dec) {
    DateTime now = DateTime.now();
    int totalDurationinSeconds = endDate.difference(startDate).inSeconds;
    int remainingDurationinSeconds = endDate.difference(now).inSeconds;
    int progress = ((totalDurationinSeconds - remainingDurationinSeconds) *
            pow(10, dec + 2)) ~/
        totalDurationinSeconds;
    return progress;
  }

  double _calculateRequireSecond(
      DateTime startDate, DateTime endDate, int dec) {
    return endDate.difference(startDate).inSeconds / pow(10, dec + 2);
  }

  void _setInitProgress() {
    globalProgress = (joinDate != null && dischargeDate != null)
        ? _calculateProgress(joinDate!, dischargeDate!, 7)
        : 0;
    vacationProgress = (preOutingDate != null &&
            nextVacationDate != null &&
            dischargeDate != null)
        ? _calculateProgress(preOutingDate!, nextVacationDate!, 5)
        : 0;
    egressionProgress = (preOutingDate != null &&
            nextEgressionDate != null &&
            dischargeDate != null)
        ? _calculateProgress(preOutingDate!, nextEgressionDate!, 5)
        : 0;
  }

  Widget buildProgressBar(
    BuildContext context, {
    required String title,
    required double progress,
    required String endDate,
    required double titleFontSize,
    required double topDateFontSize,
    required double bottomPercentFontSize,
    bool fullWidth = false,
  }) {
    String formattedProgress = title == '전역'
        ? progress.toStringAsFixed(7)
        : progress.toStringAsFixed(5);

    return Container(
      height: MediaQuery.of(context).size.height * 0.125,
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: fullWidth
                ? MediaQuery.of(context).size.width - 40
                : (MediaQuery.of(context).size.width - 40) / 2,
            child: LinearPercentIndicator(
                percent: progress / 100,
                lineHeight: title == '전역' ? 9 : 6,
                backgroundColor: Colors.blueGrey.shade100,
                progressColor: Color.fromARGB(255, 0, 27, 105)),
          ),
          Positioned(
            top: 25,
            left: 10,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 25,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                endDate,
                style: TextStyle(
                  fontSize: topDateFontSize,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 27,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '$formattedProgress%',
                style: TextStyle(
                  fontSize: bottomPercentFontSize,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildProgressBars(
    BuildContext context, {
    required String vacationTitle,
    required double vacationProgress,
    required String nextVacationDate,
    required String egressionTitle,
    required double egressionProgress,
    required String nextEgressionDate,
    required double titleFontSize,
    required double topDateFontSize,
    required double bottomPercentFontSize,
    double topPadding = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        children: [
          Expanded(
            child: buildProgressBar(
              context,
              title: vacationTitle,
              progress: vacationProgress,
              endDate: nextVacationDate,
              titleFontSize: titleFontSize,
              topDateFontSize: topDateFontSize,
              bottomPercentFontSize: bottomPercentFontSize,
            ),
          ),
          Expanded(
            child: buildProgressBar(
              context,
              title: egressionTitle,
              progress: egressionProgress,
              endDate: nextEgressionDate,
              titleFontSize: titleFontSize,
              topDateFontSize: topDateFontSize,
              bottomPercentFontSize: bottomPercentFontSize,
            ),
          )
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13.0),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLine() {
    return Container(
      height: 0.5,
      width: double.infinity,
      color: Colors.grey,
    );
  }
}
