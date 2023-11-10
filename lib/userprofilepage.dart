//This page is meant to be where they go after submitting their report.
//It's supposed to have user data and let them view report.
//I couldn't implement report retrieval functionality because firebase kept asking for billing info
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfilePage extends StatelessWidget {
  final User user;

  UserProfilePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display profile picture
            CircleAvatar(
              backgroundImage: AssetImage('assets/img/default_profile.png'), // Provide the default profile image
              radius: 50,
            ),

            SizedBox(height: 16),
            // Display user's email
            Text('Email: ${user.email}'),
            SizedBox(height: 16),

            // Display reports by the user
            Text('Reports Submitted:'),
            Expanded(
              child: StreamBuilder(//Detect changes in the reports
                stream: FirebaseFirestore.instance
                    .collection('hazard_reports')
                    .where('user_id', isEqualTo: user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  var reports = snapshot.data?.docs;
                  return ListView.builder(//Produce a list of reports
                    itemCount: reports?.length,
                    itemBuilder: (context, index) {
                      var report = reports?[index];
                        return ListTile(
                        title: Text(report?['description']),
                        subtitle: Image.network(report?['image_url']),

                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
