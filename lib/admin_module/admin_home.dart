import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Manager_module/All_employees/all_employees.dart';
import 'package:ems/Manager_module/announcement.dart';
import 'package:ems/admin_module/all_employees.dart';
import 'package:ems/admin_module/all_mangers.dart';
import 'package:ems/admin_module/allannouncements.dart';
import 'package:ems/admin_module/announcements.dart';
import 'package:ems/admin_module/checkattendance.dart';
import 'package:ems/admin_module/registartionrequest.dart';
import 'package:ems/admin_module/takeattendance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as b;

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[50],
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      drawer: Drawer(
        width: 280,
        backgroundColor: Colors.blue[50],
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, right: 145),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blueGrey[800],
                  backgroundImage: NetworkImage(
                      "https://i.pinimg.com/564x/dc/8b/ca/dc8bcad7040068e6051c00543695f3db.jpg"),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'admin.app@gmail.com',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 150),
                child: Text('Admin'),
              ),
              const SizedBox(
                height: 50,
              ),
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
                  })
            ]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10)),
                  width: 350,
                  height: 60,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('Status', isEqualTo: 'Not Approved')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        int _requestsCount = snapshot.data?.size ?? 0;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                ' Manager Registration Request',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              b.Badge(
                                badgeContent: Text(
                                  '$_requestsCount',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return manregistartion();
                                      }));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Text(
                                      'Check now',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ],
                          ),
                        );
                      })),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 170,
                    height: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Allmangers();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'All Managers',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  SizedBox(
                    width: 170,
                    height: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Allemployeee();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'All Employees',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 170,
                    height: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Announcements();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'Announcements',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  SizedBox(
                    width: 170,
                    height: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Allannouncemnets();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'All Announcements',
                          style: TextStyle(color: Colors.blue[50]),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 170,
                    height: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Attendance();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'Take Attendance',
                          style: TextStyle(color: Colors.blue[50]),
                        )),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  SizedBox(
                    width: 170,
                    height: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CheckAttendance();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'Check Attendance',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
