import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManAttendance extends StatefulWidget {
  const ManAttendance({super.key});

  @override
  State<ManAttendance> createState() => _ManAttendanceState();
}

class _ManAttendanceState extends State<ManAttendance> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final output = snapshot.data!.data();
            final name = output!['Fullname'];
            final email = output['Email'];
            final Eid = output['EID'];
            final totalcount = output['total_count'];
            final presentcount = output['present_count'];
            final absentcount = output['absent_count'];
            final url = output['Url'];

            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue[400],
                  centerTitle: true,
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: const Text(
                    'My Attendance',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
                body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(url),
                                radius: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    Eid,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Total attendance taken: $totalcount',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Presence: $presentcount',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Absence: $absentcount',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ])));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
