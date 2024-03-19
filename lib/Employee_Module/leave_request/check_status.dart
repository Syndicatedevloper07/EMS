import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class requestStatus extends StatefulWidget {
  const requestStatus({super.key});

  @override
  State<requestStatus> createState() => _requestStatusState();
}

class _requestStatusState extends State<requestStatus> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  final _security = FirebaseFirestore.instance
      .collection('leaveRequests')
      .where('request', isEqualTo: 'pending')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Check-Status',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
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
                child: Text('No requests available'),
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
                              '${docs[index]['fromDate']}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          Text('${docs[index]['toDate']}'),
                        ],
                      ),
                      title: Text('${docs[index]['reason']}'),
                      // leading: CircleAvatar(
                      //   backgroundImage: Image.network(
                      //     docs[index]['Url'],
                      //   ).image,
                      //   radius: 40,
                      // ),
                      // subtitle: Text("${docs[index]['Enrollment']}"),
                      contentPadding: const EdgeInsets.all(8),
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return ShowApp(
                        //     docID: docID[index],
                        //   );
                        // }));
                      },
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
