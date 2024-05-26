import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageData extends StatelessWidget {
  String icon;
  final double width;
  ImageData(this.icon, {Key? key, this.width = 55}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      icon,
      width: width! / Get.mediaQuery.devicePixelRatio,
    );
  }
}

class IconsPath {
  static String get homeOff => 'assets/images/bottom_nav_home_off_icon.jpg';
  static String get homeOn => 'assets/images/bottom_nav_home_on_icon.jpg';
  static String get menuIcon => 'assets/images/menu_icon.jpg';
}

class AvatarPath {
  // armyAvatar2.psd 저작권 LovePik https://kr.lovepik.com/image-401442767/army.html
  // armyAvatar.png 저작권 LovePik https://kr.lovepik.com/image-380213994/cartoon-soldier-army-clipart-the-boys-the-army-military.html
  static String get armyAvatar => 'assets/images/armyAvatar.png';
  static String get navyAvatar => 'assets/images/navyAvatar.jpg';
  // 저작권 표시 <a href="https://www.flaticon.com/kr/free-icons/" title="공군 아이콘">공군 아이콘 제작자: afitrose - Flaticon</a>
  static String get airForceAvatar => 'assets/images/airForceAvatar.png';
}
