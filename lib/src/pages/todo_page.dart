import 'package:flutter/material.dart';
import 'package:flutter_ace/models/todo_model.dart';
import 'package:flutter_ace/services/database/todo_database.dart';
import 'package:flutter_ace/widgets/todo_add_task_dialog.dart';
import 'package:flutter_ace/widgets/todo_item_widget.dart';

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
    db.loadData().then((a) {  // 화면 로드 시 데이터베이스에서 데이터를 가져옴
      if (db.toDoList.isEmpty) {  // 로드된 데이터가 없다면
        db.createInitialData();  // 초기 데이터 생성
      }
    }).catchError((error) {
      print('todo initState error: $error');
    });
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
                db.updateDataBase(task).then((value) => setState(() {}));  // 변경된 데이터를 데이터베이스에 업데이트
              });
            },
            onDelete: () {
              setState(() {
                db.deleteDataBase(task).then((value) => setState(() {}));  // 할 일 목록에서 해당 아이템 삭제
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
            var newTask = ToDoModel(name: _taskController.text);  // 입력한 텍스트를 기반으로 새로운 할 일 생성

            db.addDataBase(newTask).then((value) => setState(() {}));  // 할 일 목록에 새로운 아이템 추가
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
