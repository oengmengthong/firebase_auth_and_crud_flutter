import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  CollectionReference todos = FirebaseFirestore.instance.collection('todos');

  Future<void> _addTodo() {
    return todos.add({
      'content': _textEditingController.text,
      'done': false,
    }).then((value) {
      print("Todo Added");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todo Added Successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      print("Failed to add todo: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Add Todo'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  Future<void> _updateTodo(DocumentSnapshot doc, bool newValue) {
    return todos.doc(doc.id).update({'done': newValue}).then((value) {
      print("Todo Updated");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todo Updated Successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      print("Failed to update todo: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Update Todo'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  Future<void> _deleteTodo(DocumentSnapshot doc) {
    return todos.doc(doc.id).delete().then((value) {
      print("Todo Deleted");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todo Deleted Successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      print("Failed to delete todo: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Delete Todo'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _textEditingController,
          onSubmitted: (text) {
            _addTodo();
          },
        ),
        ElevatedButton(
          onPressed: _addTodo,
          child: Text('Add Todo'),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: todos.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['content']),
                    leading: Checkbox(
                      value: data['done'],
                      onChanged: (newValue) {
                        _updateTodo(document, newValue!);
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTodo(document);
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
