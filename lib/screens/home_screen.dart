import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/firestore.dart';
import 'package:crud/screens/signin_screen.dart';
import 'package:crud/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final FirestoreService firebaseService = FirestoreService();

  void openNoteBox({String? docId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docId== null){
                firebaseService.addNotes(textEditingController.text);
              }
              else{
                firebaseService.updateNote(docId, textEditingController.text);
              }

              textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(color: hexStringToColor("FFFFFF")),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("CB2B93"),
                hexStringToColor("9546C4"),
                hexStringToColor("5E61F4"),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200], // Couleur du fond du cadre
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: firebaseService.getNotesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List notesList = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = notesList[index];

                    String docId = document.id;

                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    String noteText = data['note'];

                    return ListTile(
                      title: Text(
                        noteText,
                        style: TextStyle(color: hexStringToColor("9546C4")),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        IconButton(
                        onPressed: ()=>openNoteBox(docId:docId ),
                        icon: const Icon(Icons.settings)),

                        IconButton(
                        onPressed: ()=>firebaseService.deleteNote(docId),
                        icon: const Icon(Icons.delete)),
                      ],),
                    );
                  },
                );
              } else {
                return const Text("No Notes !!!!");
              }
            },
          ),
        ),
      ),
    );
  }
}
