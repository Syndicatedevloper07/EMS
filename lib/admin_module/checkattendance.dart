import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/admin_module/admin_home.dart';
import 'package:ems/admin_module/attendanceInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAttendance extends StatefulWidget {
  const CheckAttendance({super.key});

  @override
  State<CheckAttendance> createState() => _CheckAttendanceState();
}

class _CheckAttendanceState extends State<CheckAttendance> {
  final _security = FirebaseFirestore.instance
      .collection('users')
      .where('Role', isEqualTo: 'Manager')
      .where('Status', isEqualTo: 'Approved')
      .snapshots();
  final userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AdminHome();
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
      body: StreamBuilder(
        stream: _security,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('connection error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No pending requests'),
            );
          }

          List docID = [];
          List docAIDSID = [];

          var docs = snapshot.data!.docs;
          snapshot.data!.docs.forEach((element) {
            docID.add(element.id);
            // Notification_Services().showNotification(
            //     title: "Request", body: "Student Request");
          });

          print(docAIDSID);

          print(docID);
          return ListView.builder(
              itemCount: docID.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: Color.fromARGB(255, 237, 238, 243),
                      trailing: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              'Presence',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          Text(
                              '${(docs[index]['percentage'] as double).toStringAsFixed(2)}%'),
                        ],
                      ),
                      title: Text('${docs[index]['Fullname']}'),
                      leading: CircleAvatar(
                        backgroundImage: Image.network(
                          docs[index]['Url'],
                        ).image,
                        radius: 40,
                      ),
                      subtitle: Text("Emp-ID: ${docs[index]['EID']}"),
                      contentPadding: const EdgeInsets.all(8),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AttendanceInfo(
                            docID: docID[index],
                          );
                        }));
                      },
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
