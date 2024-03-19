import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Employee_Module/leave_request/leave_request_home.dart';
import 'package:ems/Employee_Module/salary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmpHome extends StatefulWidget {
  const EmpHome({super.key});

  @override
  State<EmpHome> createState() => _EmpHomeState();
}

class _EmpHomeState extends State<EmpHome> {
  logOut() async {
    await FirebaseAuth.instance.signOut();
  }

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

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue[900],
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  'Home',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
              drawer: Drawer(
                width: 280,
                backgroundColor: Colors.white,
                elevation: 0,
                child: ListView(padding: const EdgeInsets.all(0), children: [
                  DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blue[900]),
                      child: UserAccountsDrawerHeader(
                          decoration: BoxDecoration(color: Colors.blue[900]),
                          accountName: Padding(
                            padding: EdgeInsets.only(top: 28),
                            child: Text(
                              name,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          accountEmail: Text(
                            email,
                            style: TextStyle(color: Colors.white),
                          ),
                          currentAccountPictureSize: const Size.square(60),
                          currentAccountPicture: Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(url),
                            ),
                          ))),
                  ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Update Profile'),
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return const Profilepage();
                        // }));
                      }),
                  ListTile(
                      leading: const Icon(Icons.speaker_notes),
                      title: const Text('Announcement'),
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return const Profilepage();
                        // }));
                      }),
                  ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('LogOut'),
                      onTap: () async {
                        setState(
                          () async {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            await logOut();
                          },
                        );
                        logOut();
                      }),
                ]),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome,',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                    ),
                    Text(name,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700)),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Your Tracks:',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600)),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 150,
                            height: 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const LeaveHome();
                                  }));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CircleAvatar(
                                      child: Icon(
                                        Icons.medication,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Leave             ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ))),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: 310,
                        height: 100,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(
                                        Icons.insights,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('My Attendance',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ))),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Task Management',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 150,
                            height: 100,
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CircleAvatar(
                                      child: Icon(
                                        Icons.task,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('My Tasks',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ))),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                            width: 150,
                            height: 100,
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          child: Icon(
                                            Icons.group,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('My Team',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400))
                                  ],
                                )))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 175,
                            height: 100,
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CircleAvatar(
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Contact Manager',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ))),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
