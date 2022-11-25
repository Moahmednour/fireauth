import 'package:fireauth/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<FirebaseApp> _initializatizeFirebase() async {
    FirebaseApp app = await Firebase.initializeApp();
    return app;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('fIREBASE AUTHENTICATION'),
        ),
        body: FutureBuilder(
          future: _initializatizeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Login();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

class Login extends StatefulWidget {
  // final VoidCallback onClickSignup;

  // const Login({Key? key, required this.onClickSignup}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.')));
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("WELCOME",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const Text("Login",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 44.0),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          SizedBox(height: 26.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 12.0),
          const Text("Forgot Password?",
              style: TextStyle(fontSize: 16, color: Colors.blue)),
          const SizedBox(height: 88.0),
          SizedBox(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.blue,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              onPressed: () async {
                User? user = await loginUsingEmailPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context);
                print(user);
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Profile()));
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text("Login",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          SizedBox(height: 20),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(color: Colors.black),
              // children: [
              //   TextSpan(
              //     text: "Sign Up",
              //     style: TextStyle(
              //         color: Colors.blue,
              //         decoration: TextDecoration.underline),
              //     recognizer: TapGestureRecognizer()
              //       ..onTap = Widget.onClickSignup,
              //   )
              // ]
            ),
          )
        ],
      ),
    );
  }
}
