import 'package:flutter/material.dart';
import 'package:hello/db_handler.dart';
import 'package:hello/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;

  late Future<List<NotesModels>> notesList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<NotesModels>> snapshot) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          
                          child: Card(
                            margin: EdgeInsets.all(5),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title:
                                  Text(snapshot.data![index].title.toString()),
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper!
              .insert(NotesModels(
                  title: 'First Notes',
                  age: 22,
                  description: 'This is my first app',
                  email: 'vishalgupta@gmail.com'))
              .then((value) {
            print('Data added successfully');
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
