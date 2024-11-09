import 'package:el_realproject/model/user.dart';
import 'package:el_realproject/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:el_realproject/services/database.dart';

class EditProfileScreen extends StatefulWidget {

// user details will be retrieved from home screen
  final UserDetails userDetails;
  EditProfileScreen(this.userDetails);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();

}



class _EditProfileScreenState extends State<EditProfileScreen> {
//image file
  XFile? _image;

//user basic information
  User? currentUser = FirebaseAuth.instance.currentUser;

  //pick function will let the user to open the gallery
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

  //text edit controller
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _icNumberController = TextEditingController();
   String _imageUrl ="";

   //UI
  @override
  Widget build(BuildContext context) {
    setUserAdditionalData(widget.userDetails);
    setCurrentUserData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit My Account'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Displays the image
            if (_image != null)
              Image.file(File(_image!.path), width: 150, height: 150)
            else
              GestureDetector(
                onTap: () async {
                  _pickImage(ImageSource.gallery);
                },
                child:  CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 65,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(_imageUrl),
                  ),
                ),
              ),

            SizedBox(height: 20),

            Text(
              "Username",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(height: 2), //
            TextField(
              controller: _usernameController,
              // Bind this text field to _usernameController

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
            //disabled because the user can't change it
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
            //disabled because the user can't change it
            TextField(
              enabled: false,
              controller: _passwordController,
              // Bind this text field to _passwordController
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
              controller: _icNumberController,
              // Bind this text field to _emailController

              decoration: InputDecoration(
                hintText: 'I.C. Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20), //
            //save button will the user to save user image and update the user record on firestore
            ElevatedButton(
              onPressed: () async {
                String? imageUrl = "";
                if (_image != null) {
                imageUrl= await StorageService().uploadImage(_image!.path);
                }
                  DatabaseService(uid: currentUser!.uid).setUserData(
                      UserDetails(
                          address: _addressController.text.trim(),
                          phoneNumber: _phoneNumberController.text.trim(),
                          icNumber: _icNumberController.text.trim(),
                          username: _usernameController.text.trim(),
                          imageUrl: imageUrl.toString()));
                  Navigator.pop(context);

              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }


  //This function used to set the user extra details
  Future<void> setUserAdditionalData(UserDetails userDetails) async {
    _usernameController.text = userDetails.username;
    _addressController.text = userDetails.address;
    _phoneNumberController.text = userDetails.phoneNumber;
    _icNumberController.text = userDetails.icNumber;
    _imageUrl=userDetails.imageUrl;
  }

  //This function used to set the user basic details
  Future<void> setCurrentUserData() async {
    _emailController.text = currentUser!.email!;
    //fake static display because the password can;t be changed
    _passwordController.text = "xxxxxxxx";
  }
}
