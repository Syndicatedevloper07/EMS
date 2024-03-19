import 'package:ems/Employee_Module/leave_request/acceptedleaves.dart';
import 'package:ems/Employee_Module/leave_request/check_status.dart';
import 'package:ems/Employee_Module/leave_request/request_leave.dart';
import 'package:flutter/material.dart';

class LeaveHome extends StatefulWidget {
  const LeaveHome({super.key});

  @override
  State<LeaveHome> createState() => _LeaveHomeState();
}

class _LeaveHomeState extends State<LeaveHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Leaves',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
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
                            return const Requestpage();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            CircleAvatar(
                              child: Icon(
                                Icons.add,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Request Leave',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400))
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
                            return const requestStatus();
                          }));
                        },
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
                                    Icons.check,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Check status',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400))
                          ],
                        )))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 150,
                height: 100,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const acceptedLeaves();
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        CircleAvatar(
                          child: Icon(
                            Icons.check_box,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Accepted Leaves',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400))
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
