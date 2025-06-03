import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'colors.dart';
import 'config.dart';

class DashboardPage extends StatefulWidget {
  final String token;
  const DashboardPage({required this.token, Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // late String userId;
  late String userId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isNotValid = false;
  List<Map<String, String>> todoItems = List.generate(
    10,
        (index) => {
      'title': 'Task #${index + 1}',
      'description': 'This is task number ${index + 1}'
    },
  );

  void _deleteItem(int index) {
    setState(() {
      // todoItems.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
      userId = jwtDecodedToken['id'] ?? 'No id found';
      print('Decoded Token: $jwtDecodedToken'); // Debug: Check token contents
    } catch (e) {
      userId = 'Error decoding token: $e';
      print('Token Error: $e'); // Debug: Log token error
    }
  }

  void addTodo() async{
    if(_titleController.text.isNotEmpty && _descController.text.isNotEmpty){
      var regBody = {
        "userId":userId,
        "title":_titleController.text,
        "desc":_descController.text
      };

      var response = await http.post(Uri.parse(addingtodo),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(regBody)
      );

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']){
        _titleController.clear();
        _descController.clear();
        Navigator.pop(context);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
            duration: Duration(seconds: 3), // Stays visible for 3 seconds
            backgroundColor: Colors.red, // Optional: Red to indicate error
          ),
        );
      }


    }

    else{
      setState(() {
        // _isNotValidate= true;
      });
    }
  }

  void _showCreateTodoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: const OutlineInputBorder(),
                  errorText: _isNotValid && _titleController.text.isEmpty
                      ? 'Please enter a title'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: const OutlineInputBorder(),
                  errorText: _isNotValid && _descController.text.isEmpty
                      ? 'Please enter a description'
                      : null,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without action
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addTodo(); // Call addTodo to handle creation and show popup
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
        backgroundColor: Color(0xFF6B48FF),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6B48FF), Color(0xFF00C4B4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 16),
                    Text(
                      'Your Tasks',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: todoItems.length,
                  itemBuilder: (context, index) {
                    return _buildTaskCard(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTodoDialog();
        },
        backgroundColor: Color(0xFF00C4B4),
        child: const Icon(Icons.add),
        tooltip: 'Add Todo',
      ),
    );
  }

  Widget _buildTaskCard(int index) {
    final item = todoItems[index];
    return Slidable(
      key: ValueKey(item['title']),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (context) => _deleteItem(index),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: const Icon(Icons.task, color: Colors.deepPurple),
          title: Text(
            '${index + 1}. ${item['title']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(item['description']!),
          trailing: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.grey),
          onTap: () {
            // Handle onTap if needed
          },
        ),
      ),
    );
  }
}