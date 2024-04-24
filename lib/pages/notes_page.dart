import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:note/components/drawer.dart';
import 'package:note/models/note.dart';
import 'package:note/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //text controller
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  //create node
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // create button
          MaterialButton(
            onPressed: () {
              // add to db
              context.read<NoteDatabase>().addNote(textController.text);
              // clear controller
              textController.clear();
              // pop dialog box
              Navigator.pop(context);
            },
            child: const Text("Tạo mới"),
          )
        ],
      ),
    );
  }

  // read note
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // update note
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sửa"),
        content: TextField(controller: textController),
        actions: [
          // update button
          MaterialButton(onPressed: (){
            // update note in db
            context.read<NoteDatabase>().updateNote(note.id , textController.text);
            // clear controller
            textController.clear();
            // pop dialog box
            Navigator.pop(context);
          },
          child: const Text("cập nhật"),
          )
        ],
      ),
    );
  }

  // delete note
  void deleteNote(int id){
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    // Note database
    final noteDatabase = context.watch<NoteDatabase>();
    // current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // heading
          const Padding(
            padding: EdgeInsets.only(left:25.0),
            // child: Text('Notes',style: GoogleFonts.dmSerifText(fontSize: 48,color: Theme.of(context).colorScheme.inversePrimary),),
            child: Text('Notes'),

          ),

          // list of note
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                //get individual note
                final note = currentNotes[index];
                //list title
                return ListTile(
                  title: Text(note.text),
                  trailing: Row(mainAxisSize: MainAxisSize.min, 
                  children: [
                    //edit button
                    IconButton(
                      onPressed: () => updateNote(note),
                      icon: const Icon(Icons.edit),
                    ),
            
            
                    //delete button
                     IconButton(
                      onPressed: () => deleteNote(note.id),
                      icon: const Icon(Icons.delete),
                    )
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
