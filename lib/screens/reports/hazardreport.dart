import 'package:el_realproject/model/report.dart';
import 'package:el_realproject/screens/reports/reports.dart';
import 'package:el_realproject/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:el_realproject/services/storage.dart';

class HazardReportingScreen extends StatefulWidget {
  @override
  _HazardReportingScreenState createState() => _HazardReportingScreenState();
}

class _HazardReportingScreenState extends State<HazardReportingScreen> {
  //image file
  XFile? _image;

  //text edit controller
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();

  //function will call the image picker and let him choose an image or capture an image
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      //image callback
      setState(() {
        _image = image;
      });
    }
  }

  //submit function will save image on storage and add report to firestore
  Future<void> _submitReport() async {
    // all field are required otherwise an error will be shown
    if (_image == null ||
        _descriptionController.text.isEmpty ||
        _departmentController.text.isEmpty ||
        _dateTimeController.text.isEmpty) {
      //error snack
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select an image, departement, time and provide a description')),
      );
      return;
    }
    //hide keyboard
    FocusScope.of(context).unfocus();

    //retrieving image from image storage
    String? imageUrl = await StorageService().uploadImage(_image!.path);

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      //add report to firestore
      DatabaseService(uid: currentUser!.uid).addReport(Report(
          uid: currentUser.uid,
          description: _descriptionController.text,
          imageUrl: "$imageUrl",
          reference: "${DateTime.now().millisecondsSinceEpoch}",
          dateTime: _dateTimeController.text,
          location: "N/A",
          status: Status.pending.name));
      //end of adapted code

      //success message snack
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thank you submiting our team will check it and revert back')),
      );
      //redirect to previous screen
      Navigator.pop(context);
    } catch (error) {

      //error message snack
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while uploading the image')),
      );
    }
  }

  //UI
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm');
    String formattedDate = formatter.format(now);
    _dateTimeController.text = formattedDate;
    return Scaffold(
      //Title
      appBar: AppBar(
        title: Text('Hazard Reporting'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Displays the image
            if (_image != null) Image.file(File(_image!.path), width: 300, height: 300),

            // This button will fire image picker function which will open the gallery
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick an Image'),
            ),

            // This button will fire image picker function which will open the camera
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take a Picture'),
            ),
            SizedBox(height: 10), //

            //description field
            Text(
              "Description",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            TextFormField(
              //Enter the description here
              controller: _descriptionController,

              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Extra Details',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 6), //

            //department field
            Text(
              "Department",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            TextFormField(
              //Enter the description here
              controller: _departmentController,
              decoration: InputDecoration(
                hintText: 'Department',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 6), //

            //date/time field
            Text(
              "Date/Time",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            TextFormField(
              //Enter the description here
              controller: _dateTimeController,
              decoration: InputDecoration(
                hintText: 'Date/Time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20), //

            //This button will fire submit report function
            ElevatedButton(
              //Button to submit a report
              onPressed: _submitReport,
              child: Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
