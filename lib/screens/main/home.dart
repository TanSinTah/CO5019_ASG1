import 'package:el_realproject/model/user.dart';
import 'package:el_realproject/screens/auth/welcome.dart';
import 'package:el_realproject/screens/main/editprofile.dart';
import 'package:el_realproject/screens/reports/hazardreport.dart';
import 'package:el_realproject/screens/reports/reports.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_realproject/services/database.dart';
import 'package:el_realproject/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  //auth service
  final AuthService _auth = AuthService();

  //text edit controller
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _icNumberController = TextEditingController();

  //logout function used to clear user data and take the user to the welcome screen
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await _auth.signOut();
    await prefs.setBool('islogin', false);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => WelcomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
//database service called to request the user details based on uid
    dynamic _stream = DatabaseService(uid: currentUser!.uid).getUserDetails();
    return StreamBuilder<DocumentSnapshot>(
        stream: _stream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
          UserDetails? userDetails;
          //checking if user data are available
          if (snapshot.data != null) {
            userDetails = UserDetails.fromSnapshot(snapshot.data);
            setUserAdditionalData(userDetails);
          }
          setCurrentUserData();
          //ui
          return Scaffold(
            appBar: AppBar(
              title: Text('My Account'),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //condition to check if user image is available
                  Row(children: [
                    if (snapshot.data != null &&
                        userDetails != null &&
                        userDetails.imageUrl != null)
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 65,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(userDetails.imageUrl),
                        ),
                      )
                    else
                      CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 65,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.transparent,
                          )),
                    SizedBox(width: 20),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Pressing this button will take the user to edit profile screen
                          ElevatedButton(
                            onPressed: () =>
                            {
                              if (userDetails != null)
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen(userDetails!)))
                                }
                            },
                            child: Text('Edit Profile'),
                          ),
                          SizedBox(height: 6),
                          //Pressing this button will take the user to resolved report screen
                          ElevatedButton(
                            onPressed: () =>
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReportsScreen(
                                              Status.resolved, userDetails)))
                            },
                            child: Text('View Resolved'),
                          ),
                          SizedBox(height: 6),
                          //Pressing this button will take the user to pending report screen
                          ElevatedButton(
                            onPressed: () =>
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReportsScreen(
                                              Status.pending, userDetails)))
                            },
                            child: Text('View Pending'),
                          ),
                          SizedBox(height: 6),
                          //Pressing this button will take the user to report hazard screen
                          ElevatedButton(
                            onPressed: () =>
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HazardReportingScreen()))
                            },
                            child: Text('Report a Hazard'),
                          ), SizedBox(height: 6),

                          //Pressing this button will fire logout function
                          ElevatedButton(
                            onPressed: () =>
                            {
                              logout()
                            },
                            child: Text('Logout'),
                          ),
                        ]),
                  ]),
                  //Displays the image

                  SizedBox(height: 10),
//Info about the user
                  Text(
                    "Username",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2), //
                  TextField(
                    enabled: false,
                    controller: _usernameController,
                    // Bind this text field to _emailController

                    decoration: InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 6), //
                  Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2), //
                  TextField(
                    enabled: false,
                    controller: _emailController,
                    // Bind this text field to _emailController

                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 6), //
                  Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2), //
                  TextField(
                    enabled: false,
                    controller: _passwordController,
                    // Bind this text field to _emailController
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 6), //
                  Text(
                    "Address",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2), //
                  TextField(
                    enabled: false,
                    controller: _addressController,
                    // Bind this text field to _emailController

                    decoration: InputDecoration(
                      hintText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 6), //
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2), //
                  TextField(
                    enabled: false,
                    controller: _phoneNumberController,
                    // Bind this text field to _emailController

                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "I.C. Number",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2),
                  TextField(
                    enabled: false,
                    controller: _icNumberController,
                    // Bind this text field to _emailController

                    decoration: InputDecoration(
                      hintText: 'I.C. Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                ],
              ),
            ),
          );
          ;
        });
  }

  //This function used to set the user extra details
  Future<void> setUserAdditionalData(UserDetails userDetails) async {
    _usernameController.text = userDetails.username;
    _addressController.text = userDetails.address;
    _phoneNumberController.text = userDetails.phoneNumber;
    _icNumberController.text = userDetails.icNumber;
  }

  //This function used to set the user basic details
  Future<void> setCurrentUserData() async {
    _emailController.text = currentUser!.email!;
    //fake static display because the password can;t be changed
    _passwordController.text = "xxxxxxxx";
  }
}
