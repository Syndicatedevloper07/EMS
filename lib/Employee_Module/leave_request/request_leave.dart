import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Requestpage extends StatefulWidget {
  const Requestpage({Key? key}) : super(key: key);

  @override
  State<Requestpage> createState() => _RequestpageState();
}

class _RequestpageState extends State<Requestpage> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  bool isSubmitting = false;
  int leaveCount = 1;
  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  Future<void> sendDataToFirebase() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      // Access your Firebase Firestore instance
      if (fromDateController.text.isNotEmpty ||
          toDateController.text.isNotEmpty ||
          reasonController.text.isNotEmpty) {
        CollectionReference requests =
            FirebaseFirestore.instance.collection('leaveRequests');
        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
        // Add a new document with data
        await requests.add({
          'fromDate': fromDateController.text,
          'toDate': toDateController.text,
          'reason': reasonController.text,
          'TOS': currentTime,
          'request': 'pending',
          'leavecount': leaveCount++

          // Add other fields as needed
        });

        // Reset the text fields after sending data
        fromDateController.clear();
        toDateController.clear();
        reasonController.clear();

        // Optionally, show a success message or navigate to another screen

        // Show success dialog
        _showAlertDialog('Success', 'Leave request sent successfully!');
      } else {
        _showAlertDialog('Failed', 'Please Fill All the Fields');
      }
    } catch (e) {
      // Handle errors here
      print("Error sending data to Firebase: $e");

      // Show error dialog
      _showAlertDialog(
          'Error', 'Failed to send leave request. Please try again.');
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Request Leave',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Date:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    height: 70,
                    child: TextFormField(
                      controller: fromDateController,
                      maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'TO',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 120,
                    height: 70,
                    child: TextFormField(
                      controller: toDateController,
                      maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Reason:',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: reasonController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 70,
                width: 320,
                child: ElevatedButton(
                  onPressed: () {
                    sendDataToFirebase();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isSubmitting
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    'Total Remaining Leaves this month:',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text('4/4',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20))
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
