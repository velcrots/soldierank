import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;  // 버튼에 표시될 텍스트
  final VoidCallback onPressed;  // 버튼 클릭 시 실행될 함수

  const CustomButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,  // 버튼 색상
      child: Text(label),  // 버튼 텍스트
    );
  }
}