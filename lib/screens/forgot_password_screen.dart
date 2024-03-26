
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          const Gap(16),

          const Text('Please provide your email.\nWe will send an email for password reset',
          textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),

          const Gap(16),

          TextField(
            controller: emailC,
            decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder()),
          ),
          const Gap(16),

          ElevatedButton(onPressed: () async {

            String email = emailC.text.trim();

            if( email.isNotEmpty){


              try{
                await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

                Fluttertoast.showToast(msg: 'Email Sent', fontSize: 30);
              }on FirebaseAuthException catch (e){
                Fluttertoast.showToast(msg: e.message!, fontSize: 30);
              }
            }else{
              Fluttertoast.showToast(msg: "please provide email");
            }
          }, child: const Text('Submit')),

        ],),
      ),
    );
  }
}
