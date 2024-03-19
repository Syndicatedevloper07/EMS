import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/admin_module/all_mangers.dart';
import 'package:flutter/material.dart';

class Allmaninfo extends StatefulWidget {
  Allmaninfo({super.key, required this.docID});

  String docID;
  @override
  State<Allmaninfo> createState() => _AllmaninfoState();
}

class _AllmaninfoState extends State<Allmaninfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Manager Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Allmangers();
              }));
            },
            icon: Icon(Icons.arrow_back)),
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
