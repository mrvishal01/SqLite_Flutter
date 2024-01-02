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
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onLongPress: () {
                              dbHelper!.update(NotesModels(
                                  id: snapshot.data![index].id!,
                                  title: 'Vishal Notes',
                                  age: 21,
                                  description: 'Notes',
                                  email: 'ABC@GMAIL.COM'));
                              setState(() {
                                notesList = dbHelper!.getNotesList();
                              });
                            },
                            child: Dismissible(
                              key: ValueKey<int>(snapshot.data![index].id!),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete),
                              ),
                              onDismissed: (direction) {
                                setState(() {
                                  dbHelper!.delete(snapshot.data![index].id!);
                                  print('data sucessfully deleted');
                                  notesList = dbHelper!.getNotesList();
                                  snapshot.data!.remove(snapshot.data![index]);
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                      snapshot.data![index].title.toString()),
                                  subtitle: Text(
                                      snapshot.data![index].age.toString()),
                                  trailing: Text(
                                      snapshot.data![index].email.toString()),
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper!
              .insert(NotesModels(
                  title: 'Third Notes',
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
