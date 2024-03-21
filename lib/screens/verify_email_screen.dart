import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
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

          ElevatedButton(onPressed: (){}, child: const Text('Resend Email')),

        ],),
      ),
    );
  }
}
