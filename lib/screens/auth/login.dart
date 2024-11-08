import 'package:flutter/material.dart';
import 'package:el_realproject/screens/main/home.dart';
import 'package:el_realproject/screens/auth/forgotpassword.dart';
import 'package:el_realproject/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(home: LoginScreen()));//runApp(MyApp());
// }

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //auth service
  final AuthService _auth = AuthService();

  //text edit controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorText = '';

  //login function used to firebase sign in
  Future<void> _login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic  userCredential = await _auth.signInWithEmailAndPassword(
         _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if(userCredential!=null)
        {
          await prefs.setBool('islogin', true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }else{
        print('Login failed');
        setState(() {

          _emailController.clear();
          _passwordController.clear();
          _errorText = 'Incorrect email or password. Please retry.';
        });
      }

      print(userCredential);
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
              SizedBox(height: 20), // Adjust the margin
              Image.asset(
                'assets/img/Logo.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 15), // Adjust the margin
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController, // Bind this text field to _emailController

                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Adjust the margin
                    TextField(
                      controller: _passwordController, // Bind this text field to _passwordController

                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    //forget password button will take the user to the forget password screen
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xff007bff),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
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
                    //back button will take the user to the last screen
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to the first screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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

