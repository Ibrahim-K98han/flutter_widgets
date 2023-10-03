
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  Box? notepad;
  @override
  void initState() {
    notepad = Hive.box('notepad');
    super.initState();
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController _updateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Write Something'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final userInput = _controller.text;
                  await notepad!.add(userInput);
                  _controller.clear();
                  Fluttertoast.showToast(msg: 'Added successfully');
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
              child: Text('Add new data'),
            ),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: Hive.box('notepad').listenable(),
              builder: (context, box, widget) {
                return ListView.builder(
                  itemCount: notepad!.keys.toList().length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Container(
                                          height: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: _updateController,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Write something'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    final updatedData =
                                                        _updateController.text;
                                                    notepad!.putAt(
                                                        index, updatedData);
                                                    _updateController.clear();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Update'),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await notepad!.deleteAt(index);
                                  Fluttertoast.showToast(
                                      msg: 'Delete Successfully');
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                        title: Text(
                          notepad!.getAt(index).toString(),
                        ),
                      ),
                    );
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
