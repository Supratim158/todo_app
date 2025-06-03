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
  List? items;

  void deleteItem(id) async{
    var regBody = {
      "id":id
    };

    var response = await http.post(Uri.parse(deletTodo),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );

    var jsonResponse = jsonDecode(response.body);
    if(jsonResponse['status']){
      getTodoList(userId);
    }

  }

    @override
    void initState() {
      super.initState();
      try {
        Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
        userId = jwtDecodedToken['id'] ?? 'No id found';
        print('Decoded Token: $jwtDecodedToken'); // Debug: Check token contents
        getTodoList(userId);
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
          getTodoList(userId);
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog without action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent, // Button background color
                  foregroundColor: Colors.white, // Text and icon color
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  addTodo(); // Call addTodo to handle creation and show popup
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button background color
                  foregroundColor: Colors.white, // Text and icon color
                ),
                child: const Text('Create'),
              ),
            ],
          );
        },
      );
    }

    void getTodoList(userId) async {
    var regBody = {
      "userId":userId
    };

    var response = await http.post(Uri.parse(getToDoList),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );

    var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['success'];

    setState(() {

    });
  }


  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color(0xFF02B3DA),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 120.0,left: 30.0,right: 30.0,bottom: 90.0),
              child: Column(
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(child: Icon(Icons.list_alt_rounded,size: 30.0,),backgroundColor: Colors.white,radius: 30.0,),
                      SizedBox(width: 19.0),
                      Text('ToDo',style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.w700),),
                  
                    ],
                  ),
                  Text('UserId: $userId',style: TextStyle(fontSize: 18.5,fontWeight: FontWeight.w700))
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: 1000,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: items == null ? null : ListView.builder(
                      itemCount: items!.length,
                      itemBuilder: (context,int index){
                        return Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {}),
                            children: [
                              SlidableAction(
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (BuildContext context) {
                                  print('${items![index]['_id']}');
                                  deleteItem('${items![index]['_id']}');

                                },
                              ),
                            ],
                          ),
                          child: Card(
                            borderOnForeground: false,
                            child: ListTile(
                              leading: Icon(Icons.task),
                              title: Text('${items![index]['title']}'),
                              subtitle: Text('${items![index]['desc']}'),
                              trailing: Icon(Icons.arrow_back_ios),
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>_showCreateTodoDialog() ,
          backgroundColor: Color(0xFF02B3DA),
          child: Icon(Icons.add),
          tooltip: 'Add-ToDo',
        ),
      );
    }
  }