import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin_login.dart';
import 'package:sehealthyapp/services/auth_service.dart';

class SignUpAdminPage extends StatefulWidget {
  @override
  _SignUpAdminPageState createState() => _SignUpAdminPageState();
}

class _SignUpAdminPageState extends State<SignUpAdminPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _agreedToTOS = false;

  Future<void> _registerAdmin() async {
    if (_formKey.currentState!.validate() && _agreedToTOS) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        // TODO: Add additional admin role saving logic if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully!')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF2FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(Icons.health_and_safety, color: Colors.blue, size: 64),
                SizedBox(height: 12),
                Text(
                  'SeHealthy',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Create Account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  'Sign up to track your health journey',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 24),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(_fullNameController, 'Full Name', Icons.person),
                      SizedBox(height: 12),
                      _buildTextField(_emailController, 'Email Address', Icons.email,
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 12),
                      _buildTextField(_passwordController, 'Password', Icons.lock,
                          isPassword: true),
                      SizedBox(height: 12),
                      _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock,
                          isPassword: true),
                      SizedBox(height: 12),

                      Row(
                        children: [
                          Checkbox(
                            value: _agreedToTOS,
                            onChanged: (value) => setState(() => _agreedToTOS = value ?? false),
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                Text('I agree to the '),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'Terms of Service',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                Text(' and '),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'Privacy Policy',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      ElevatedButton(
                        onPressed: _registerAdmin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2764FF),
                          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Sign Up Admin'),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text('Already have an account? Log In'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: 'Enter your ${hint.toLowerCase()}',
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $hint';
        if (hint == 'Confirm Password' && value != _passwordController.text)
          return 'Passwords do not match';
        return null;
      },
    );
  }
}
