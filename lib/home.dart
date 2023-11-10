//This page is the make a report page I just misnamed it.
import 'package:el_realproject/userprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HazardReportingPage extends StatefulWidget {
  @override
  _HazardReportingPageState createState() => _HazardReportingPageState();
}

class _HazardReportingPageState extends State<HazardReportingPage> {
  XFile? _image;
  String _description = '';

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _submitReport() async {
    if (_image == null || _description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and provide a description')),
      );
      return;
    }
    //code from Gitanjal, 2022

    // Upload image to Firebase Storage
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    //Set up references to upload images
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(_image!.path));
      String imageUrl = await referenceImageToUpload.getDownloadURL();


      final firestore = FirebaseFirestore.instance;
      User? currentUser = FirebaseAuth.instance.currentUser;
      //Add a new report
      await firestore.collection('hazard_reports').add({
        'description': _description,
        'image_url': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    //end of adapted code

      // Clear the form or navigate to the user profile page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserProfilePage(currentUser!)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while uploading the image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hazard Reporting'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [//Displays the image
            if (_image != null) Image.file(File(_image!.path)),

            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick an Image'),
            ),

            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take a Picture'),
            ),

            TextFormField(//Enter the description here
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),

            ElevatedButton(//Button to submit a report
              onPressed: _submitReport,
              child: Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}

