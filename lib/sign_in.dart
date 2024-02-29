import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'sign_up.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _auth.signInWithEmailAndPassword(email, password);
                  }
                },
                child: Text('Sign In'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text('Sign Up'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signInWithGoogle();
                },
                child: Text('Sign In with Google'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signInAnonymously();
                },
                child: Text('Sign In Anonymously'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
