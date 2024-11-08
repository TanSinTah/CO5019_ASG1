import 'package:flutter/material.dart';
import 'package:el_realproject/screens/main/home.dart';
import 'package:el_realproject/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //auth service
  final AuthService _auth = AuthService();

  //text edit controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _errorText = '';

  //signup function used to firebase signup
  Future<void> _signup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic result = await _auth.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      print(result);
      if (result != null) {
        await prefs.setBool('islogin', true);
        // Clear confirm password field
        _confirmPasswordController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print('Signup failed:');
        setState(() {
          // Clear fields and set an error message
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          _errorText = 'Signup failed. Please try again.';
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
              SizedBox(height: 20),

              //top image
              Image.asset(
                'assets/img/Logo.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    //Press signup will fire sign up function
                    ElevatedButton(
                      onPressed: () {
                        if (_passwordController.text ==
                            _confirmPasswordController.text) {
                          _signup();
                        } else {
                          setState(() {
                            _errorText =
                                'Passwords do not match. Please try again.';
                          });
                        }
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
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
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
                    Text(
                      _errorText,
                      //Another error message for any signup erros eg. password too short
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
