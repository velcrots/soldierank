import 'package:flutter/material.dart';
import 'package:flutter_ace/models/todo_model.dart';

/// 각 할 일 항목을 표시하는 위젯
class ToDoItemWidget extends StatelessWidget {
  final ToDoModel item;  // 할 일 아이템 정보
  final ValueChanged<bool?> onChanged;  // 체크박스 변경 시 실행될 함수
  final VoidCallback onDelete;  // 삭제 버튼 클릭 시 실행될 함수

  const ToDoItemWidget({super.key, required this.item, required this.onChanged, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.teal[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // ListTile의 좌측에 체크박스를 표시하여 완료 여부 선택
                Checkbox(
                  value: item.isCompleted,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                ),
                Text(
                  item.name,
                  style: TextStyle(
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough  // 완료된 할 일은 취소선 표시
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
            // ListTile에 삭제 버튼 추가
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),  // 삭제 아이콘
              onPressed: onDelete,
            )
          ],
        ),
      ),
    );
  }
}