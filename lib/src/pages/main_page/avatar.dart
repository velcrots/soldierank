import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  Avatar({Key? key, required this.soldiertype}) : super(key: key);

  final String soldiertype;

  @override
  Widget build(BuildContext context) {
    switch (soldiertype) {
      case '해군':
        return Image(
          image: AssetImage('assets/images/navyAvatar.jpg'),
          fit: BoxFit.contain,
        );
      case '육군':
        return Image(
          image: AssetImage('assets/images/armyAvatar.png'),
          fit: BoxFit.contain,
        );
      case '공군':
        return Image(
          image: AssetImage('assets/images/airForceAvatar.png'),
          fit: BoxFit.contain,
        );
      default:
        return Image(
          image: AssetImage('assets/images/avatar.jpg'),
          fit: BoxFit.contain,
        );
    }
  }
}
