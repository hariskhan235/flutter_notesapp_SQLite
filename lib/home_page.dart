import 'package:flutter/material.dart';
import 'package:flutter_notes_app/app/db/notes_db.dart';
import 'package:flutter_notes_app/model/notes_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
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
        title: const Text('My Note Application'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: notesList,
              builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          dbHelper!.update(
                            NotesModel(
                                id: snapshot.data![index].id!,
                                title: 'Some thing else',
                                age: 34,
                                description: 'This is something else',
                                email: 'ishaqzaada235@gmail.com'),
                          );
                          setState(() {
                            notesList = dbHelper!.getNotesList();
                          });
                        },
                        child: Dismissible(
                          onDismissed: (DismissDirection direction) {
                            setState(() {
                              dbHelper!.deleteNote(snapshot.data![index].id!);
                              notesList = dbHelper!.getNotesList();
                              snapshot.data!.remove(snapshot.data![index]);
                            });
                          },
                          key: ValueKey<int>(snapshot.data![index].id!),
                          child: Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text(
                                snapshot.data![index].title.toString(),
                              ),
                              subtitle: Text(
                                snapshot.data![index].description.toString(),
                              ),
                              trailing: Text(
                                snapshot.data![index].age.toString(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dbHelper!
              .insert(
            NotesModel(
              title: 'Second Notes',
              age: 24,
              description: 'This is my Second note in my flutter application',
              email: 'Harisromeo9@gmail.com',
            ),
          )
              .then((value) {
            print('data added successfully');
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
          }).onError((error, stackTrace) {
            print(
              error.toString(),
            );
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
