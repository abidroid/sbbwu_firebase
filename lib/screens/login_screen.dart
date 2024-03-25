import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:sbbwu_firebase/screens/dashboard_screen.dart';
import 'package:sbbwu_firebase/screens/forgot_password_screen.dart';
import 'package:sbbwu_firebase/screens/sign_up_screen.dart';
import 'package:sbbwu_firebase/screens/verify_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder()
              ),
            ),

            const Gap(16),
            TextField(
              controller: passC,
              obscureText: obscureText,
              decoration:  InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      obscureText = !obscureText;
                    });

                  }, icon: Icon( obscureText ?  Icons.visibility : Icons.visibility_off)),
                  border: const OutlineInputBorder()
              ),
            ),
            TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.centerRight
                ),
                onPressed: (){

                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return const ForgotPasswordScreen();
                  }));

                }, child: const Text('Forgot Password?',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),)),


            ElevatedButton(onPressed: () async {

              String email = emailC.text.trim();
              if( email.isEmpty){
                Fluttertoast.showToast( msg: 'Please provide email');
                return;
              }
              String password = passC.text.trim();
              if( password.isEmpty){
                Fluttertoast.showToast( msg: 'Please provide password');
                return;
              }

              FirebaseAuth auth = FirebaseAuth.instance;

              try{
                UserCredential userCredentials = await auth.signInWithEmailAndPassword(email: email, password: password);

                if( userCredentials.user != null ){

                  // check if email is verified

                  if( userCredentials.user!.emailVerified){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return const DashboardScreen();
                    }));
                  }else{

                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return const VerifyEmailScreen();
                    }));
                  }


                }


              }on FirebaseAuthException catch (e){
                Fluttertoast.showToast(msg: e.message ?? '');
              }





            }, child: const Text('Login')),

            const Gap(16),

            TextButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return const SignUpScreen();
              }));
            }, child: const Text('Not Registered Yet? Sign Up'))
          ],
        ),
      ),
    );
  }
}
