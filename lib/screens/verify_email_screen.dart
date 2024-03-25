import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:sbbwu_firebase/screens/dashboard_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {

  Timer? timer;

  @override
  void initState() {
    // send email to user
    FirebaseAuth.instance.currentUser!.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 5), (timer){
      checkEmailVerification();
    });
    super.initState();
  }

  checkEmailVerification() {
    FirebaseAuth.instance.currentUser!.reload();

    if( FirebaseAuth.instance.currentUser!.emailVerified){
      timer?.cancel();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
        return const DashboardScreen();
      }));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          const Gap(16),

          const Text('A verification email has been sent to you\nPlease Verify Your Email',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),

          const Gap(16),
          const SpinKitWave(color: Colors.deepOrange,),
          const Gap(16),

          ElevatedButton(onPressed: (){

            FirebaseAuth.instance.currentUser!.sendEmailVerification();

          }, child: const Text('Resend Email')),

        ],),
      ),
    );
  }
}
