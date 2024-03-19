import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManProf extends StatefulWidget {
  const ManProf({super.key});

  @override
  State<ManProf> createState() => _ManProfState();
}

class _ManProfState extends State<ManProf> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
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
            final url = output['Url'];
            final address = output['Address'];
            final mobile = output['Mobile'];

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue[400],
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                title: Text(
                  'Update Profile',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(url),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 220,
                            child: TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                  hintText: name, border: OutlineInputBorder()),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                            hintText: mobile,
                            //labelText: 'Mobile-no',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 5,
                        decoration: InputDecoration(
                            //labelText: 'Address',
                            hintText: address,
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 70,
                        width: 320,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Colors.blue[400]),
                            child: Text(
                              'Update',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 21),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
