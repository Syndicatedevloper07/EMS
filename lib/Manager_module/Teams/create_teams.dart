import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Createteam extends StatefulWidget {
  const Createteam({Key? key}) : super(key: key);

  @override
  State<Createteam> createState() => _CreateteamState();
}

class _CreateteamState extends State<Createteam> {
  List<String> selectedEmployees = [];
  TextEditingController _workController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create Team',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue[400],
        actions: [
          IconButton(
            onPressed: () {
              // Add selected employees to Firebase
              _createTeam(selectedEmployees);
            },
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('Role', isEqualTo: 'Employee')
            .where('Status', isEqualTo: 'Approved')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Text('Error fetching data');
          }

          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final employeeData =
                  documents[index].data() as Map<String, dynamic>;
              final employeeId = documents[index].id;
              final bool isSelected = selectedEmployees.contains(employeeId);

              return ListTile(
                title: Text(employeeData['Fullname']),
                subtitle: Text(employeeData['department']),
                leading: CircleAvatar(
                  child: Text(employeeData['Fullname'][0]),
                ),
                trailing: IconButton(
                  icon: isSelected
                      ? const Icon(Icons.check_box)
                      : const Icon(Icons.check_box_outline_blank),
                  onPressed: () {
                    setState(() {
                      if (isSelected) {
                        selectedEmployees.remove(employeeId);
                      } else {
                        selectedEmployees.add(employeeId);
                      }
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAssignWorkDialog();
        },
        child: const Icon(Icons.assignment),
      ),
    );
  }

  void _createTeam(List<String> selectedEmployees) async {
    try {
      // Create a new document in the 'teams' collection
      final teamRef = FirebaseFirestore.instance.collection('teams').doc();

      // Construct the team data
      final teamData = {
        'teamId': teamRef.id,
        'members': selectedEmployees,
        'createdAt': Timestamp.now(),
      };

      // Save the team data to Firestore
      await teamRef.set(teamData);

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Team created successfully!'),
        ),
      );

      // Clear the selected employees list
      setState(() {
        selectedEmployees.clear();
      });
    } catch (error) {
      // Display an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create team: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAssignWorkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assign Work'),
          content: TextField(
            controller: _workController,
            decoration: const InputDecoration(
              hintText: 'Enter the task to assign',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _assignWork(_workController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  void _assignWork(String task) async {
    try {
      // Create a new document in the 'assigned_tasks' collection
      final taskRef =
          FirebaseFirestore.instance.collection('assigned_tasks').doc();

      // Construct the task data
      final taskData = {
        'taskId': taskRef.id,
        'task': task,
        'assignedAt': Timestamp.now(),
      };

      // Save the task data to Firestore
      await taskRef.set(taskData);

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task assigned successfully!'),
        ),
      );
    } catch (error) {
      // Display an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to assign task: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _workController.dispose();
    super.dispose();
  }
}
