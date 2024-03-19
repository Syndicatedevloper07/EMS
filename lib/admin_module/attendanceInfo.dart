import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/admin_module/checkattendance.dart';
import 'package:flutter/material.dart';

class AttendanceInfo extends StatefulWidget {
  AttendanceInfo({super.key, required this.docID});

  String docID;
  @override
  State<AttendanceInfo> createState() => _AttendanceInfoState();
}

class _AttendanceInfoState extends State<AttendanceInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CheckAttendance();
                }));
              },
              icon: Icon(Icons.arrow_back)),
          centerTitle: true,
          title: Text(
            'Attendance Data ',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.blue[50],
        ),
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
                    final totalcount = output['total_count'];
                    final presentcount = output['present_count'];
                    final absentcount = output['absent_count'];
                    final url = output['Url'];

                    return Padding(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                            ]));
                  } else {
                    return CircularProgressIndicator();
                  }
                })));
  }
}
