import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ace/src/components/image_data.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  String userId = '';
  MainPage(this.userId, {Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Timer _timer;

  DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');

  String soldierType = '';
  DateTime now = DateTime.now();
  DateTime? joinDate;
  DateTime? dischargeDate;
  DateTime? preOutingDate;
  DateTime? nextVacationDate;
  DateTime? nextEgressionDate;
  double globalProgress = 0.0;
  double vacationProgress = 0.0;
  double egressionProgress = 0.0;

  Future<Map> _callAPI(String idText) async {
    var url = Uri.parse(
      'http://navy-combat-power-management-platform.shop/getInfo.php',
    );
    var response = await Dio().postUri(url, data: {'username': idText});
    Map result = response.data;
    print(result);
    return result;
  }

  @override
  void initState() {
    super.initState();
    Future<Map> future = _callAPI(widget.userId);
    future.then((val) {
      setState(() {
        soldierType = val['사용자'][0]['군별'];
        joinDate = _parseDate(val['사용자'][0]['입대일'] ?? '');
        dischargeDate = _parseDate(val['사용자'][0]['전역일'] ?? '');
        preOutingDate = _parseDate(val['사용자'][0]['최근_복귀일'] ?? '');
        nextVacationDate = _parseDate(val['휴가'][0]['출발_날짜'] ?? '');
        nextEgressionDate = _parseDate(val['외출'][0]['출발_날짜'] ?? '');
      });
    }).catchError((error) {
      print('error: $error');
    });
    _timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
      updateProgress();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                      }
                    })(),
                  ),
                ),
              ),
            ),

            // 전역 프로그레스 바
            buildProgressBar(
              context,
              title: '전역',
              progress: globalProgress,
              endDate: dischargeDate != null
                  ? DateFormat('yyyy-MM-dd').format(dischargeDate!)
                  : '',
              titleFontSize: 13,
              topDateFontSize: 12,
              bottomPercentFontSize: 12,
              fullWidth: true,
              bottomPadding: 0,
            ),

            // 휴가 및 외출 프로그레스 바
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: buildProgressBars(
                context,
                vacationTitle: '다음 휴가',
                vacationProgress: vacationProgress,
                nextVacationDate: nextVacationDate != null
                    ? DateFormat('yyyy-MM-dd').format(nextVacationDate!)
                    : '-',
                egressionTitle: '다음 외출',
                egressionProgress: egressionProgress,
                nextEgressionDate: nextEgressionDate != null
                    ? DateFormat('yyyy-MM-dd').format(nextEgressionDate!)
                    : '-',
                titleFontSize: 12,
                topDateFontSize: 11,
                bottomPercentFontSize: 11,
                topPadding: 0,
              ),
            ),

            // 일정 관련 Text
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
                          ? now.difference(joinDate!).inDays.toString()
                          : ''),
                  buildLine(),
                  buildInfoRow(
                      '남은 복무일',
                      dischargeDate != null
                          ? dischargeDate!.difference(now).inDays.toString()
                          : ''),
                  buildLine(),
                  buildInfoRow(
                      '다음 휴가까지',
                      nextVacationDate != null
                          ? now.difference(nextVacationDate!).inDays.toString()
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

  double _calculateProgress(DateTime startDate, DateTime endDate) {
    // 현재 시간을 가져옴
    DateTime now = DateTime.now();

    // Calculating total duration in seconds
    int totalDurationInSeconds = endDate.difference(startDate).inSeconds;

    // Calculating the remaining duration in seconds
    int remainingDurationInSeconds = endDate.difference(now).inSeconds;

    // Calculating the progress
    double progress = (totalDurationInSeconds - remainingDurationInSeconds) /
        totalDurationInSeconds;

    // Making sure progress is between 0 and 1
    progress = progress.clamp(0.0, 1.0);

    return progress;
  }

  void updateProgress() {
    setState(() {
      // 현재 시간을 가져옴
      now = DateTime.now();

      // 전역 프로그레스 바 업데이트
      globalProgress = (joinDate != null && dischargeDate != null)
          ? _calculateProgress(joinDate!, dischargeDate!)
          : 0;

      // 휴가 및 외출 프로그레스 바 업데이트
      vacationProgress = (preOutingDate != null &&
              nextVacationDate != null &&
              dischargeDate != null)
          ? _calculateProgress(preOutingDate!, nextVacationDate!)
          : 0;
      egressionProgress = (preOutingDate != null &&
              nextEgressionDate != null &&
              dischargeDate != null)
          ? _calculateProgress(preOutingDate!, nextEgressionDate!)
          : 0;
    });
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
    double bottomPadding = 10.0,
  }) {
    String formattedProgress = title == '전역'
        ? (progress * 100).toStringAsFixed(7)
        : (progress * 100).toStringAsFixed(5);

    return Container(
      height: MediaQuery.of(context).size.height * 0.125,
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottomPadding),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: fullWidth
                ? MediaQuery.of(context).size.width - 40
                : (MediaQuery.of(context).size.width - 40) / 2,
            child: LinearPercentIndicator(
              percent: progress,
              lineHeight: 5,
              backgroundColor: Colors.blueGrey.shade100,
              progressColor: Colors.teal.shade400,
            ),
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
              bottomPadding: 0,
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
              bottomPadding: 0,
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
