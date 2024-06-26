import 'package:flutter/material.dart';
import 'package:flutter_ace/src/components/image_data.dart';
import 'package:flutter_ace/src/controller/bottom_nav_controller.dart';
import 'package:flutter_ace/src/pages/assessment_page.dart';
import 'package:flutter_ace/src/pages/group_page.dart';
import 'package:flutter_ace/src/pages/main_page/main_page.dart';
import 'package:flutter_ace/src/pages/todo_page.dart';
import 'package:flutter_ace/src/pages/trainig_page.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class App extends GetView<BottomNavController> {
  App({Key? key}) : super(key: key);

  static const String defalutId = '1234567890';
  static String userId = defalutId;

  @override
  Widget build(BuildContext context) {
    userId =
        (ModalRoute.of(context)?.settings.arguments ?? defalutId) as String;
    return WillPopScope(
        onWillPop: controller.willPopAction,
        child: Obx(
          () => Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    print('Menu button clicked');
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      print('Settings button clicked');
                    },
                  ),
                ],
              ),
            ),
            body: IndexedStack(
              index: controller.pageIndex.value,
              children: [
                MainPage(),
                AssessmentPage(),
                TrainingPage(),
                TodoPage(),
                GroupPage(),
                Container(
                  child: Center(child: Text('home5')),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: controller.pageIndex.value,
                elevation: 10,
                onTap: controller.changeBottomNav,
                items: [
                  BottomNavigationBarItem(
                    icon: ImageData(IconsPath.homeOff),
                    activeIcon: ImageData(IconsPath.homeOn),
                    label: 'home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.assessment_outlined),
                    activeIcon: Icon(Icons.assessment),
                    label: 'statistics',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.cyclone_outlined),
                    activeIcon: Icon(Icons.cyclone),
                    label: 'training',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.done),
                    activeIcon: Icon(Icons.done_all),
                    label: 'todo',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.group),
                    activeIcon: Icon(Icons.group),
                    label: 'group',
                  ),
                ],
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey),
          ),
        ));
  }
}
