import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Manager_module/manHomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Announcement extends StatefulWidget {
  const Announcement({super.key});

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  bool _isUploading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _blogController = TextEditingController();

  final uID = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference blogs = FirebaseFirestore.instance.collection('Announce');

  Future<void> updateDocumentWithCurrentTime() async {
    try {
      var now = DateTime.now();
      var formatter = DateFormat('dd-MM-yyyy');
      String formattedDate = formatter.format(now);
      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

      await _firestore.collection('Announce').doc(uID).update({
        'date': formattedDate,
        'time': currentTime,
      });
      print('Document updated with current time.');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  void _post() async {
    String title = _titleController.text.trim();
    String blog = _blogController.text.trim();

    if (title.isEmpty || blog.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          closeIconColor: Colors.white,
          showCloseIcon: true,
          backgroundColor: Colors.blue[900],
          content: const Text(
            'Please fill out all fields.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      setState(() {
        _isUploading = true;
      });

      try {
        var now = DateTime.now();
        var formatter = DateFormat('dd-MM-yyyy');
        String formattedDate = formatter.format(now);
        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
        await blogs.add({
          'Title': title,
          'Subject': blog,
          'date': formattedDate,
          'time': currentTime,
        });

        // Navigate to the success screen or perform other actions as needed
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const ManHome();
        }));
      } catch (error) {
        print('Error uploading data: $error');
        // Handle errors, display a snackbar, or perform other error handling
      } finally {
        // Hide CircularProgressIndicator
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _titleController.dispose();
    _blogController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Make Announcement',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue[400],
        actions: [
          _isUploading
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    _post();
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
          // IconButton(
          //     onPressed: () {

          //       _post();
          //     },
          //     icon: const Icon(
          //       Icons.check,
          //       color: Colors.white,
          //     ))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ManHome();
              }));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                maxLength: 40,
                controller: _titleController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter title here'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _blogController,
                maxLines: 13,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write the announcement here..'),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
