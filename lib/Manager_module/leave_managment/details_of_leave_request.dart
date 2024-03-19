import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Manager_module/manHomepage.dart';
import 'package:flutter/material.dart';

class DLR extends StatefulWidget {
  DLR({super.key, required this.docID});
  String docID;
  @override
  State<DLR> createState() => _DLRState();
}

class _DLRState extends State<DLR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Leave Requests',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[400],
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('leaveRequests')
                .doc(widget.docID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final output = snapshot.data!.data();
                final reason = output!['reason'];
                final fromDate = output['fromDate'];
                final todate = output['toDate'];

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
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Reason: ',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${reason}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        // fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              diplayInfo("From", fromDate),
                              diplayInfo('to', todate),
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
                                  return const ManHome();
                                }));
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('leaveRequests')
                                      .doc(widget.docID)
                                      .update({'request': "Approved"});
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
                                  return const ManHome();
                                }));
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('leaveRequests')
                                      .doc(widget.docID)
                                      .update({'request': "Denied"});
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
          Expanded(
            child: Text(
              " ${string}",
              softWrap: true,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
