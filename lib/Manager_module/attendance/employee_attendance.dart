import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Manager_module/manHomepage.dart';
import 'package:ems/admin_module/admin_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmpAttend extends StatefulWidget {
  const EmpAttend({Key? key}) : super(key: key);

  @override
  State<EmpAttend> createState() => _EmpAttendState();
}

class _EmpAttendState extends State<EmpAttend> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _security =
      FirebaseFirestore.instance
          .collection('users')
          .where('Role', isEqualTo: 'Employee')
          .where('Status', isEqualTo: 'Approved')
          .snapshots();
  final userid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, bool> _attendanceStatus = {};

  Future<void> _storeAttendanceData(String userId, bool isPresent) async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      final userData = await userDocRef.get();

//<----------------------count--------------------------------------------------------->
      int totalcount = 0;
      int presentcount = 0;
      int absentcount = 0;
      double percentage = 0;
      bool isPresent;
      if (isPresent = true) {
        totalcount = totalcount + 1;
        presentcount = presentcount + 1;
        absentcount = absentcount + 0;
        percentage = (presentcount / totalcount) * 100;
      } else if (isPresent = false) {
        totalcount = totalcount + 1;
        absentcount = absentcount + 1;
        presentcount = presentcount + 0;
        percentage = (absentcount / totalcount) * 100;
      }

//<-----------------------------count end ------------------------------------------->

      final attendanceData = {
        'userId': userId,
        'userName': userData['Fullname'],
        'userPhoto': userData['Url'],
        'date': _getDateDocumentId(),
        'isPresent': isPresent,
        'total_count': totalcount,
        'present_count': totalcount,
        'absent_count': absentcount,
      };

      // Store the attendance data in the 'attendance' collection with the document ID as the current date
      await FirebaseFirestore.instance
          .collection('users')
          .doc()
          // .doc(_getDateDocumentId())
          .update(attendanceData);
    } catch (e) {
      print('Error storing attendance data: $e');
    }
  }

  Future<void> _updateAttendance(String userId, bool isPresent) async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Get the current user's data
      final userData = await userDocRef.get();

      // Retrieve existing counts from Firestore or initialize to default values
      int totalcount = userData['total_count'] ?? 0;
      int presentcount = userData['present_count'] ?? 0;
      int absentcount = userData['absent_count'] ?? 0;

      // Update counts based on the new attendance status
      if (isPresent) {
        presentcount++;
      } else {
        absentcount++;
      }
      totalcount++;

      // Recalculate percentage
      double percentage = (presentcount / totalcount) * 100;

      // Define the structure of the attendance document
      final attendanceData = {
        'userId': userId,
        'userName': userData['Fullname'],
        'userPhoto': userData['Url'],
        'date': _getDateDocumentId(),
        'isPresent': isPresent,
        'total_count': totalcount,
        'present_count': presentcount,
        'absent_count': absentcount,
        'percentage': percentage
      };

      // Store the updated attendance data in the 'users' collection
      await userDocRef.update(attendanceData);
    } catch (e) {
      print('Error updating attendance: $e');
    }
  }

  String _getDateDocumentId() {
    // Get the current date in the format 'yyyy-MM-dd'
    final now = DateTime.now();
    final formattedDate = '${now.year}-${now.month}-${now.day}';
    return formattedDate;
  }

  bool ispresent = false;
  bool isabsent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // final snapshots = await _security.first;
              // for (var doc in snapshots.docs) {
              //   await _updateAttendance(doc.id, true);
              // }
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const ManHome();
            }));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const Text(
          'Take Attendance',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[50],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _security,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Connection error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No pending requests'),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final userId = docs[index].id;
              bool isPresent;
              return Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: const Color.fromARGB(255, 237, 238, 243),
                    trailing: Container(
                      width: 105,
                      height: 40,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _attendanceStatus[userId] = true;
                                });
                                // Call function to update attendance when present button is pressed
                                _updateAttendance(docs[index].id, true);
                                setState(() {
                                  isPresent = true;
                                  ispresent = true;
                                });
                                // Assuming you have userId in your document
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                backgroundColor:
                                    ispresent ? Colors.green : Colors.blue,
                                foregroundColor: Colors.blue[50],
                              ),
                              child: const Text('P'),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          SizedBox(
                            width: 50,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _attendanceStatus[userId] = false;
                                });

                                _updateAttendance(docs[index].id, false);
                                setState(() {
                                  isPresent = false;
                                  isabsent = true;
                                });
                                // Assuming you have userId in your document
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isabsent ? Colors.red : Colors.blue,
                                foregroundColor: Colors.blue[50],
                              ),
                              child: const Text('A'),
                            ),
                          ),
                        ],
                      ),
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
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return Allmaninfo(
                      //     docID: docID[index],
                      //   );
                      // }));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
