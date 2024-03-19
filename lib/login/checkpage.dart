import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ems/admin_module/admin_home.dart';

import 'package:ems/Manager_module/manHomepage.dart';

import 'package:ems/Employee_Module/emphomepage.dart';

class Check_Page extends StatefulWidget {
  const Check_Page({super.key});

  @override
  State<Check_Page> createState() => _Check_PageState();
}

class _Check_PageState extends State<Check_Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final uID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uID).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final output = snapshot.data!.data();
            final _user_role = output!['Role'];
            final _status = output['Status'];
            final _isRemoved = output["Is_Removed"];
//------------------------------->Student<--------------------------------------//

            if (_isRemoved == "Yes") {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("You are Permanently Removed"),
                    InkWell(
                        onTap: () => FirebaseAuth.instance.signOut(),
                        child: Icon(Icons.logout)),
                  ],
                ),
              );
            }

            if (_user_role == 'Employee') {
              if (_status == "Approved") {
                return EmpHome();
              } else if (_status == "Not Approved") {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Your request is Pendding"),
                      InkWell(
                          onTap: () => FirebaseAuth.instance.signOut(),
                          child: Icon(Icons.logout)),
                    ],
                  ),
                );
              } else if (_status == "Denied") {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Your request is Denied"),
                      InkWell(
                          onTap: () => FirebaseAuth.instance.signOut(),
                          child: Icon(Icons.logout)),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
            //------------------------------->Faculty Member<--------------------------------------//
            else if (_user_role == 'Manager') {
              if (_status == "Approved") {
                return ManHome();
              } else if (_status == "Not Approved") {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Your request is Pendding"),
                      InkWell(
                          onTap: () => FirebaseAuth.instance.signOut(),
                          child: Icon(Icons.logout)),
                    ],
                  ),
                );
              } else if (_status == "Denied") {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Your request is Denied"),
                      InkWell(
                          onTap: () => FirebaseAuth.instance.signOut(),
                          child: Icon(Icons.logout)),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
            //------------------------------->Admin<--------------------------------------//
            else if (_user_role == 'Admin') {
              print("Admin");
              return AdminHome();
            }
            //------------------------------->Security<-------------------------------------------------------//
          } else if (snapshot.hasError) {
            print(snapshot.error);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
              ),
            );
          }
          return Center(
            child: Text('Something is wrong'),
          );
        });
  }
}
