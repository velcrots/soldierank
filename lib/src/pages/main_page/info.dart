import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final DateTime? joinDate;
  final DateTime? dischargeDate;
  final DateTime? nextVacationDate;

  const Info({
    super.key,
    required this.joinDate,
    required this.dischargeDate,
    required this.nextVacationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInfoRow(
              '전체 복무일',
              dischargeDate != null && joinDate != null
                  ? dischargeDate!.difference(joinDate!).inDays.toString()
                  : ''),
          buildLine(),
          buildInfoRow(
              '현재 복무일',
              dischargeDate != null && joinDate != null
                  ? DateTime.now().difference(joinDate!).inDays.toString()
                  : ''),
          buildLine(),
          buildInfoRow(
              '남은 복무일',
              dischargeDate != null
                  ? dischargeDate!.difference(DateTime.now()).inDays.toString()
                  : ''),
          buildLine(),
          buildInfoRow(
              '다음 휴가까지',
              nextVacationDate != null
                  ? nextVacationDate!
                      .difference(DateTime.now())
                      .inDays
                      .toString()
                  : '-'),
          const SizedBox(height: 10),
          const Text(
            '※제공되는 정보는 법적 효력 및 행정 효력이 없습니다.\n\n\n',
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget buildLine() {
    return const Divider(
      color: Colors.black,
    );
  }
}
