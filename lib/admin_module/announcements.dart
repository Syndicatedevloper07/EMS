import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/admin_module/admin_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Announcements extends StatefulWidget {
  const Announcements({super.key});

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  bool _isUploading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _blogController = TextEditingController();
  final TextEditingController _category = TextEditingController();

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
        await photo();
        var now = DateTime.now();
        var formatter = DateFormat('dd-MM-yyyy');
        String formattedDate = formatter.format(now);
        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
        await blogs.add({
          'Title': title,
          'Subject': blog,
          'url': url,
          'date': formattedDate,
          'time': currentTime,
        });

        // Navigate to the success screen or perform other actions as needed
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const AdminHome();
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

  File? file;
  ImagePicker image = ImagePicker();
  var url = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  Future photo() async {
    var imagefile = FirebaseStorage.instance
        .ref()
        .child("Blog_post")
        .child("/${_titleController.text}.jpg");
    UploadTask task = imagefile.putFile(file!);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    setState(() {
      url = url;
    });
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

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
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.blue[50],
        actions: [
          _isUploading
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.black,
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
                    color: Colors.black,
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
                return const AdminHome();
              }));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * 1,
                    child: file != null
                        ? ClipRect(
                            child: Image.file(
                              file!.absolute,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(10)),
                            width: 100,
                            height: 100,
                            child: IconButton(
                                onPressed: getImage,
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.blue,
                                )))),
              ),
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
