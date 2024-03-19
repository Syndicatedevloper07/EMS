import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/admin_module/all_mangers.dart';
import 'package:ems/admin_module/allannouncements.dart';
import 'package:flutter/material.dart';

class Annonceinfo extends StatefulWidget {
  Annonceinfo({super.key, required this.docID});

  String docID;
  @override
  State<Annonceinfo> createState() => _AnnonceinfoState();
}

class _AnnonceinfoState extends State<Annonceinfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Announcements',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Allannouncemnets();
              }));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Announce')
                .doc(widget.docID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final output = snapshot.data!.data();
                final subject = output!['Subject'];
                final title = output['Title'];
                final date = output['date'];
                final time = output['time'];

                // final insMail = output['Institution_Mail'];
                final url = output['url'];

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
                                      title,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  subject,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              //diplayInfo('Subject', subject),
                              diplayInfo("Date", date),
                              diplayInfo("Time", time),
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
