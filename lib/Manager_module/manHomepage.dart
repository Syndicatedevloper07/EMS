import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Manager_module/All_employees/all_employees.dart';
import 'package:ems/Manager_module/Teams/all_teams.dart';
import 'package:ems/Manager_module/Teams/create_teams.dart';
import 'package:ems/Manager_module/announcement.dart';
import 'package:ems/Manager_module/attendance/employee_attendance.dart';
import 'package:ems/Manager_module/err.dart';
import 'package:ems/Manager_module/leave_managment/leaverequest.dart';
import 'package:ems/Manager_module/manager_attendance.dart';
import 'package:ems/Manager_module/profile_update.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as bades;

class ManHome extends StatefulWidget {
  const ManHome({super.key});

  @override
  State<ManHome> createState() => _ManHomeState();
}

class _ManHomeState extends State<ManHome> {
  logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  int requestsCount = 0;
  int leavecount = 0;
  int employeeCount = 0;
  @override
  void initState() {
    super.initState();

    fetchRequestsCount();
    fetchLeaveCount();
    fetchemployeeCount();
  }

  void fetchRequestsCount() {
    FirebaseFirestore.instance
        .collection('users')
        .where('Role', isEqualTo: 'Employee')
        .where('Status', isEqualTo: 'Not Approved')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        requestsCount = snapshot.docs.length;
      });
    });
  }

  void fetchLeaveCount() {
    FirebaseFirestore.instance
        .collection('leaveRequests')
        .where('request', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        leavecount = snapshot.docs.length;
      });
    });
  }

  void fetchemployeeCount() {
    FirebaseFirestore.instance
        .collection('users')
        .where('Role', isEqualTo: 'Employee')
        .where('Status', isEqualTo: 'Approved')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        employeeCount = snapshot.docs.length;
      });
    });
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
                backgroundColor: Colors.blue[400],
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
                      decoration: BoxDecoration(color: Colors.blue[400]),
                      child: UserAccountsDrawerHeader(
                          decoration: BoxDecoration(color: Colors.blue[400]),
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
                      title: const Text('Profile'),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ManProf();
                        }));
                      }),
                  ListTile(
                      leading: const Icon(Icons.note),
                      title: const Text('My Attendance'),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ManAttendance();
                        }));
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome,',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w300),
                      ),
                      Text(name,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 60,
                        width: 330,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Employee Registration Request',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              bades.Badge(
                                badgeContent: Text(requestsCount.toString()),
                                child: SizedBox(
                                  height: 40,
                                  width: 90,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const Err();
                                        }));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      child: const Text('Check')),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Employee Summary',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700)),
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
                                      return const Leaverequests();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child: Icon(
                                              Icons.medication,
                                              color: Colors.red,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Text(
                                            leavecount.toString(),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('Leave',
                                          style: TextStyle(
                                              fontSize: 18,
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
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const EmpAttend();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CircleAvatar(
                                        child: Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('Attendance',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400))
                                    ],
                                  )))
                        ],
                      ),
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
                                      return const Allemployee();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.orange,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Text(
                                            employeeCount.toString(),
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('All Employees',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ))),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: 150,
                              height: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const Allemployee();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child: Icon(
                                              Icons.data_array,
                                              color: Colors.red,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('Check Attendance',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ))),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Your Employees',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
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
                                      return Createteam();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child: Icon(
                                              Icons.group_add,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('Create Team',
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
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return AllTeams();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child: Icon(
                                              Icons.group,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('All Teams',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  )))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Announcement();
                          }));
                        },
                        child: SizedBox(
                          width: 310,
                          height: 120,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const CircleAvatar(
                                    child: Icon(Icons.speaker_notes),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Make Annoucement',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
