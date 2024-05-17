import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

// ignore: constant_identifier_names
enum PageName { HOME, STATISTICS, TRAINING, TODO, GROUP }

class BottomNavController extends GetxController {
  RxInt pageIndex = 0.obs;
  List<int> bottomHistory = [0];
  DateTime? currentBackPressTime;

  void changeBottomNav(int value) {
    var page = PageName.values[value];

    if (pageIndex.value != value) {
      switch (page) {
        case PageName.HOME:
          _pageChange(value);
          _resetHistory(); // pageIndex가 0일 때 bottomHistory 초기화
          break;
        case PageName.STATISTICS:
        case PageName.TRAINING:
        case PageName.TODO:
        case PageName.GROUP:
          _pageChange(value);
          break;
      }
    }
  }

  void _pageChange(int value) {
    pageIndex(value);
    if (bottomHistory.last != value) {
      if (bottomHistory.length == 5) {
        bottomHistory.removeAt(1);
      }
      bottomHistory.add(value);
    }
    print(bottomHistory);
  }

  void _resetHistory() {
    bottomHistory = [0];
  }

  Future<bool> willPopAction() async {
    if (bottomHistory.length == 1) {
      DateTime now = DateTime.now();

      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        const msg = "뒤로가기 버튼을 한 번 더 누르면 종료됩니다.";

        Fluttertoast.showToast(msg: msg);
        return Future.value(false);
      }

      return Future.value(true);
    } else {
      bottomHistory.removeLast();
      var index = bottomHistory.last;
      changeBottomNav(index);
      return false;
    }
  }
}
