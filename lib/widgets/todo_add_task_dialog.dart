import 'package:flutter/material.dart';
import 'package:flutter_ace/widgets/todo_custom_button.dart';

class AddTaskDialog extends StatelessWidget {
  final TextEditingController controller;  // 입력한 텍스트를 관리하는 컨트롤러
  final VoidCallback onSave;  // 저장 버튼 클릭 시 실행될 함수
  final VoidCallback onCancel;  // 취소 버튼 클릭 시 실행될 함수

  const AddTaskDialog({super.key, required this.controller, required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.teal[400],
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "새로운 할 일 추가",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(label: "저장", onPressed: onSave),
                const SizedBox(width: 8),
                CustomButton(label: "취소", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}