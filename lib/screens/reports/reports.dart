import 'package:el_realproject/model/report.dart';
import 'package:el_realproject/model/user.dart';
import 'package:el_realproject/screens/main/editprofile.dart';
import 'package:el_realproject/screens/reports/hazardreport.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_realproject/services/database.dart';

class ReportsScreen extends StatefulWidget {

  final Status status;
  final UserDetails? userDetails;

  //status and user details will be retrieved from the previous screen
  ReportsScreen(this.status, this.userDetails);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

//reports status
enum Status { pending, resolved }

class _ReportsScreenState extends State<ReportsScreen> {
  //current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  //text edit controller
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _icNumberController = TextEditingController();

  //UI
  @override
  Widget build(BuildContext context) {
    Status? status = widget.status;
    UserDetails? userDetails = widget.userDetails;

    //database service called to request the user reports based on uid and status
    dynamic _stream = DatabaseService(uid: currentUser!.uid).getReports(status);
    return StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
          List<Report>? reports;
          if (snapshot.data != null) {
            //snapshot value will be converted to list of reports
            reports = snapshot.data!.docs.map((DocumentSnapshot document) {
              return Report.fromSnapshot(
                  document.data() as Map<String, dynamic>);
            }).toList();
          }

          //dynamic title
          String title = "";
          if (status == Status.pending) {
            title = "Pending Reports";
          } else {
            title = "Resolved Reports";
          }

          setCurrentUserData();
          return Scaffold(
            //title
            appBar: AppBar(
              title: Text(title),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //user image
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
                          //This button will redirect the user to the edit profile
                          ElevatedButton(
                            onPressed: () => {
                              if (userDetails != null)
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen(userDetails)))
                                }
                            },
                            child: Text('View Profile'),
                          ),
                          SizedBox(height: 6),
                          //This button will redirect the user to the resolved report
                          if (status == Status.pending)
                            ElevatedButton(
                              onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReportsScreen(
                                            Status.resolved, userDetails)))
                              },
                              child: Text('View Resolved'),
                            )
                          else
                          //This button will redirect the user to the pending report
                            ElevatedButton(
                              onPressed: () => {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReportsScreen(
                                            Status.pending, userDetails)))
                              },
                              child: Text('View Pending'),
                            ),
                          SizedBox(height: 6),
                          //This button will redirect the user to report harzard screen
                          ElevatedButton(
                            onPressed: () => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HazardReportingScreen()))
                            },
                            child: Text('Report a Hazard'),
                          ),
                        ]),
                  ]),

                  SizedBox(height: 10),
                  //Display reports list
                  if (reports != null && reports.isNotEmpty == true)
                    for (var report in reports)
                      Text(
                        "Report # ${report.reference}\n${report.description}\n${report.dateTime}\n\n",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                  else
                    Text("No Reports found",
                        style: TextStyle(
                          color: Colors.black,
                        ))
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
