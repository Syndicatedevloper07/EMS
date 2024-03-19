// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class signup extends StatefulWidget {
  final void Function()? onPressed;

  const signup({Key? key, required this.onPressed});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  String dropvalue = 'Employee';
  final item = [
    'Employee',
    'Manager',
  ];
  String? _value;
  bool isLoading = false;
  bool isRaiedException = false;

  //Dropdown Veriables -> For student Majors
  String dropvalue_stud2 = 'IT';
  final item_stud2 = ['IT', 'Marketing', 'Testing'];
  String? _value_stud2;

  //Dropdown Veriables -> For Faculty Designation
  String dropvalue_faculty2 = 'Manager';
  final item_faculty2 = [
    'Manager',
    'Asst. Manager',
  ];
  String? _value_faculty2;

  final TextEditingController _empidController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _submitForm() async {
    String emailValue = _emailController.text.trim();
    String passwordValue = _passwordController.text.trim();
    String repasswordValue = _repasswordController.text.trim();
    String fullnameValue = _fullnameController.text.trim();
    String phoneValue = _phoneController.text.trim();
    String address = _addressController.text.trim();
    String drpvalue = _value.toString();

    String department = _value_stud2.toString();

    // For faculty

    String desg = _value_faculty2.toString();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    if (fullnameValue.isEmpty ||
        phoneValue.isEmpty ||
        emailValue.isEmpty ||
        passwordValue.isEmpty ||
        repasswordValue.isEmpty) {
      // Show SnackBar if the text field is blank
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          closeIconColor: Colors.white,
          showCloseIcon: true,
          backgroundColor: Colors.blue[900],
          content: const Text(
            'Please fill out all fields.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      // Handle form submission when the text field is not blank
      // You can add your logic here
      // print('Form submitted with value: $inputValue');
      await photo();
      await signIn();
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'Address': address,
        'EID': _empidController.text.trim(),
        'Email': _emailController.text.trim(),
        'Fullname': _fullnameController.text.trim(),
        'Phone': _phoneController.text,
        'Url': url,
        "Is_Removed": "No",
      });

      //Diffrent conditions for log in
      drpvalue == 'Employee' ? await upForEmployee(drpvalue, department) : null;
      drpvalue == 'Manager' ? await upForManager(drpvalue, desg) : null;
    }
  }

  bool _password = true;
  File? file;
  ImagePicker image = ImagePicker();
  var url = '';

  Future signIn() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  Future photo() async {
    var imagefile = FirebaseStorage.instance
        .ref()
        .child("contact_photo")
        .child("/${_fullnameController.text}.jpg");
    UploadTask task = imagefile.putFile(file!);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    setState(() {
      url = url;
    });
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    _phoneController.dispose();
    _empidController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  upForEmployee(String drpvalue, String Department) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    String stud_stat = 'Not Approved';
    firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'department': Department,
      'Role': drpvalue,
      'Status': stud_stat,
    });
  }

  upForManager(String drpvalue, String designation) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    String faculty_stat = 'Not Approved';
    firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .update({
      'Role': drpvalue,
      'Designation': designation,
      'Status': faculty_stat,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create Account",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please Register Yourself to continue",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              CircleAvatar(
                backgroundColor: Colors.blue[900],
                radius: 50,
                child: CircleAvatar(
                  backgroundImage: file != null ? FileImage(file!) : null,
                  radius: 46,
                  child: file == null
                      ? IconButton(
                          iconSize: 40,
                          onPressed: getImage,
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.blue[900],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _fullnameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue[100],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                  hintText: 'Enter Full Name',
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue[100],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                  hintText: 'Enter Mobile No.',
                  prefixIcon: const Icon(Icons.call),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _addressController,
                maxLength: 100,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue[100],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                  hintText: 'Enter Address',
                  prefixIcon: const Icon(Icons.location_city),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue[100],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                  hintText: 'Enter Email-ID',
                  prefixIcon: const Icon(Icons.mail),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: _password,
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue[100],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Enter Password',
                  hintStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _password ? Icons.visibility_off : Icons.visibility),
                    color: Colors.grey.shade600,
                    onPressed: () {
                      setState(() {
                        _password = !_password;
                      });
                    },
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: _password,
                controller: _repasswordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue[100],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _password ? Icons.visibility_off : Icons.visibility),
                    color: Colors.grey.shade600,
                    onPressed: () {
                      setState(() {
                        _password = !_password;
                      });
                    },
                  ),
                  hintText: 'Enter Confirmed Password',
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter are you a student or a Teacher/Faculty member';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                value: _value,
                hint: const Text(
                  'Who are you?',
                ),
                items: item.map(buildMenuItem).toList(),
                onChanged: ((value) => setState(() => this._value = value)),
              ),
              const SizedBox(
                height: 20,
              ),
              _value == 'Employee'
                  ? foremployee()
                  : const Padding(
                      padding: EdgeInsets.zero,
                    ),
              _value == 'Manager'
                  ? forManager()
                  : const Padding(
                      padding: EdgeInsets.zero,
                    ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  children: [
                    Text(
                      'Already Have an account ?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onPressed,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              color: Colors.grey[900],
              fontWeight: FontWeight.w500), // GoogleFonts.abel(fontSize: 24),
        ),
      );
  Widget foremployee() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: DropdownButtonFormField<String>(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter are you a student or a Teacher/Faculty member';
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              value: _value_stud2,
              hint: Text('Department',
                  style: TextStyle(
                      color: Colors.white) // GoogleFonts.abel(fontSize: 24),
                  ),
              items: item_stud2.map(buildMenuItem).toList(),
              onChanged: ((value) => setState(() => this._value_stud2 = value)),
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          const SizedBox(height: 9),
          TextFormField(
            controller: _empidController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Your Roll/ Enrollment No.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Employee ID',
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget forManager() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      child: Column(
        children: [
          const SizedBox(height: 5),
          const SizedBox(height: 9),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: DropdownButtonFormField<String>(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter are you a student or a Teacher/Faculty member';
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                border: OutlineInputBorder(
                  // borderSide: BorderSide(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),

                // fillColor: Colors.grey.shade500
              ),
              value: _value_faculty2,
              hint: const Text(
                'Designation',
                style: TextStyle(color: Colors.white),
              ),
              items: item_faculty2.map(buildMenuItem).toList(),
              onChanged: ((value) =>
                  setState(() => this._value_faculty2 = value)),
            ),
          ),
          const SizedBox(height: 9),
          TextFormField(
            controller: _empidController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Your Roll/ Enrollment No.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Employee ID.',
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
