import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: TodoPage(),
  ));
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  ToDoDatabase db = ToDoDatabase();  // 할 일 데이터베이스
  bool showCompletedTasksOnly = false;  // 완료된 할 일만 보여주는지 여부
  final _taskController = TextEditingController();  // 새로운 할 일 입력을 위한 컨트롤러

  @override
  void initState() {
    super.initState();
    // Start the timer to update the UI every 1 second (60 times per second)
    db.loadData();  // 화면 로드 시 데이터베이스에서 할 일 데이터를 가져옴
    if (db.toDoList.isEmpty) {  // 로드된 데이터가 없다면
      db.createInitialData();  // 초기 데이터 생성
      db.updateDataBase();  // 생성된 초기 데이터를 데이터베이스에 저장
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Page'),
        actions: [
          IconButton(
            icon: Icon(showCompletedTasksOnly ? Icons.list : Icons.check),
            onPressed: () {
              setState(() {
                showCompletedTasksOnly = !showCompletedTasksOnly;  // 완료된 할 일만 보여주는 옵션을 토글
              });
            },
          ),
        ],
      ),

      // 교안의 Filtered List View를 사용하여 Todo List 표시
      body: ListView.builder(
        itemCount: showCompletedTasksOnly  // 완료된 할 일만 보여줄지 여부에 따라 목록 길이 결정
            ? db.toDoList.where((task) => task.isCompleted).length
            : db.toDoList.length,
        itemBuilder: (context, index) {
          var task = showCompletedTasksOnly
              ? db.toDoList.where((task) => task.isCompleted).toList()[index]
              : db.toDoList[index];
          return ToDoItemWidget(
            item: task,
            onChanged: (value) {
              setState(() {
                task.isCompleted = value!;
                db.updateDataBase();  // 변경된 데이터를 데이터베이스에 업데이트
              });
            },
            onDelete: () {
              setState(() {
                db.toDoList.remove(task);  // 할 일 목록에서 해당 아이템 삭제
                db.updateDataBase();  // 변경된 데이터를 데이터베이스에 업데이트
              });
            },
          );
        },
      ),
      // Floated Button(+) 추가
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,  // '+' 버튼 클릭 시 새로운 할 일 추가 함수 실행
        child: const Icon(Icons.add),  // 플로팅 버튼 아이콘
      ),
    );
  }

  // 새로운 할 일을 추가하는 함수
  void _addTask() {
    showDialog(
      context: context,
      // Dialog를 사용하여 할일 입력
      builder: (context) => AddTaskDialog(
        controller: _taskController,
        onSave: () {
          setState(() {
            var newTask = ToDoItem(name: _taskController.text);  // 입력한 텍스트를 기반으로 새로운 할 일 생성
            db.toDoList.add(newTask);  // 할 일 목록에 새로운 아이템 추가
            db.updateDataBase();  // 변경된 데이터를 데이터베이스에 업데이트
            _taskController.clear();  // 입력 필드 초기화
          });
          Navigator.of(context).pop();  // 다이얼로그 닫기
        },
        onCancel: () {
          _taskController.clear();  // 입력 필드 초기화
          Navigator.of(context).pop();  // 다이얼로그 닫기
        },
      ),
    );
  }
}

class ToDoItem {
  String name;  // 할 일의 이름 또는 내용
  bool isCompleted;  // 할 일의 완료 여부

  ToDoItem({required this.name, this.isCompleted = false});

  /// Map 데이터 형식에서 ToDoItem 객체로 변환
  ToDoItem.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        isCompleted = map['isCompleted'];

  /// ToDoItem 객체를 Map 데이터 형식으로 변환
  Map<String, dynamic> toMap() => {'name': name, 'isCompleted': isCompleted};
}

class ToDoDatabase {
  List<ToDoItem> toDoList = [];  // 할 일 목록을 저장하는 리스트
  final _myBox = Hive.box('hivebox');  // Hive 데이터베이스의 'hivebox' 박스

  /// 초기 데이터 생성
  void createInitialData() {
    toDoList = [
      ToDoItem(name: "운동 1시간", isCompleted: false),
      ToDoItem(name: "밥먹기", isCompleted: false),
      ToDoItem(name: "빨래하기", isCompleted: false),
    ];
  }

  void loadData() {
    var loadedData = _myBox.get("TODOLIST") as List<dynamic>? ?? [];
    toDoList = loadedData.map((item) {
      if (item is Map) {
        return ToDoItem.fromMap(item.cast<String, dynamic>());
      }
      return null;  // 잘못된 데이터 타입에 대한 처리.
    }).where((item) => item != null).cast<ToDoItem>().toList();
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList.map((e) => e.toMap()).toList());  // 'TODOLIST' 키에 리스트 데이터 저장
  }
}

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

/// 각 할 일 항목을 표시하는 위젯
class ToDoItemWidget extends StatelessWidget {
  final ToDoItem item;  // 할 일 아이템 정보
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