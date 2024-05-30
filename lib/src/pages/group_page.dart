import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ace/src/components/image_data.dart';
import 'package:video_player/video_player.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  final List<String> items =
  List<String>.generate(20, (index) => "병사 $index");
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Page'),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(items[index]),
            subtitle: Text('상태메시지 $index'),
            trailing: Icon(Icons.arrow_forward),
            selected: index < 3,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(items[index]),
                    content: Text('${items[index]} 관련 정보',),
                    actions: [
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}