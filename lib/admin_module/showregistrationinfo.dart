import 'package:ems/Manager_module/manHomepage.dart';
import 'package:ems/admin_module/admin_home.dart';
import 'package:ems/admin_module/registartionrequest.dart';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class ShowApp extends StatefulWidget {
  ShowApp({super.key, required this.docID});

  String docID;

  @override
  State<ShowApp> createState() => _ShowAppState();
}

class _ShowAppState extends State<ShowApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        title: const Text(
          'Requests',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue[50],
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.docID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final output = snapshot.data!.data();
                final name = output!['Fullname'];
                final Eid = output['EID'];
                final Email = output['Email'];
                final address = output['Address'];
                final phone = output['Phone'];

                // final insMail = output['Institution_Mail'];
                final url = output['Url'];

                // Status of faculty
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        child: Card(
                          // elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                url,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Name: ',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${name}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        // fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              diplayInfo("Emp-ID", Eid),
                              diplayInfo('Email', Email),
                              diplayInfo("Add.", address),
                              diplayInfo("Phone no.", phone),
                            ],
                          ),
                        ),
                      ),
                      ///////////////////////////////////////////////////////// Buttons ///////////////////////////////
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 60,
                            width: 170,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const AdminHome();
                                }));
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.docID)
                                      .update({'Status': "Approved"});
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.greenAccent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                minimumSize: const Size(100, 40), //////// HERE
                              ),
                              child: const Text(
                                "Approve",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          SizedBox(
                            height: 60,
                            width: 170,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const manregistartion();
                                }));
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.docID)
                                      .update({'Status': "Denied"});
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue,
                                shadowColor: Colors.greenAccent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                minimumSize: const Size(100, 40), //////// HERE
                              ),
                              child: const Text(
                                "Decline",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /*Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 9,
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5, // Elevation
                                shadowColor: Colors.purple, // Shadow Color
                              ),
                              onPressed: () {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('Form')
                                      .doc(widget.docID)
                                      .update({'Status': "Approved"});
                                  updateDocumentWithCurrentTime();
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Approved",
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      ),*/
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return Center(child: Text("Connection Issuses"));
            }),
      ),
    );
  }

  Widget diplayInfo(String info, String string) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            "${info}:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            " ${string}",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
