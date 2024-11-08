import 'package:flutter/material.dart';
import 'package:el_realproject/screens/auth/login.dart';
import 'package:el_realproject/services/auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  String _errorText = '';

  //forget password function used to firebase reset password
  Future<void> _forgetPassword() async {
      dynamic response =
          await _auth.sendPasswordResetEmail(_emailController.text.trim());
      if (response==true) {
        _emailController.clear();
        _errorText = '';
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset link sent. Please check your email')),
        );
      } else {
        print('Forget Password failed');
        setState(() {
          FocusScope.of(context).unfocus();
          _emailController.clear();
          _errorText = 'Incorrect email. Please retry.';
        });
      }

  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //top image
              Image.asset(
                'assets/img/Logo.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              Text(
                textAlign: TextAlign.center,
                "You are here because you selected Forgot Password. Please enter your email address or call us to have your password changed.",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      // Bind this text field to _emailController

                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _forgetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff007bff),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //number for support
                    Text(
                      "Phone Number: +673 7985286",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff007bff),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    //back button will take the user to the last screen
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to the first screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Go Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    //Display incorrect username or password
                    Text(
                      _errorText,
                      style: TextStyle(
                        color: Colors.red,
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
}
