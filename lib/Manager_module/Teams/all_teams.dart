import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllTeams extends StatefulWidget {
  const AllTeams({Key? key});

  @override
  State<AllTeams> createState() => _AllTeamsState();
}

class _AllTeamsState extends State<AllTeams> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'All Teams',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('teams').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final teams = snapshot.data!.docs;

          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final teamData = teams[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('Team ID: ${teamData['teamId']}'),
                subtitle: Text('Members: ${teamData['members'].join(', ')}'),
                // You can display other team information here
              );
            },
          );
        },
      ),
    );
  }
}
