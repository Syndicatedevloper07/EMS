import 'package:flutter/material.dart';

class salary extends StatefulWidget {
  const salary({super.key});

  @override
  State<salary> createState() => _salaryState();
}

class _salaryState extends State<salary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Salary',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(),
    );
  }
}
