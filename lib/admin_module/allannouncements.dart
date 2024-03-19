import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/admin_module/admin_home.dart';
import 'package:ems/admin_module/showannounse.dart';
import 'package:flutter/material.dart';

class Allannouncemnets extends StatefulWidget {
  const Allannouncemnets({super.key});

  @override
  State<Allannouncemnets> createState() => _AllannouncemnetsState();
}

class _AllannouncemnetsState extends State<Allannouncemnets> {
  final _security = FirebaseFirestore.instance
      .collection('Announce')
      .orderBy('date', descending: true)
      .snapshots();
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
          'All Announcements',
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
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Announcements Available'),
              );
            }

            var docs = snapshot.data!.docs;
            List<String> docID = [];

            snapshot.data!.docs.forEach((element) {
              docID.add(element.id);
            });

            print(docID);

            return ListView.builder(
                itemCount: docID.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height / 7,
                          width: MediaQuery.of(context).size.width / 4,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Annonceinfo(
                                    docID: docID[index],
                                  );
                                }));
                              },
                              child: Container(
                                decoration:
                                    BoxDecoration(color: Colors.blue[50]),
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 4,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRect(
                                        child: Image.network(
                                          '${docs[index]['url']}',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              8,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 100,
                                      width: 180,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${docs[index]['Title']}',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            '${docs[index]['date']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ))));
                });
          }),
    );
  }
}
