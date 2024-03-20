
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController mobileC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(
                  hintText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()
              ),
            ),

            const Gap(16),

            TextField(
              keyboardType: TextInputType.number,
              maxLength: 11,
              controller: mobileC,
              decoration: const InputDecoration(
                  hintText: 'Mobile',
                  prefixIcon: Icon(Icons.mobile_friendly),
                  border: OutlineInputBorder()
              ),
            ),

            const Gap(16),
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

            const Gap(16),
            ElevatedButton(onPressed: (){}, child: const Text('Sign Up')),


            TextButton(onPressed: (){
             Navigator.pop(context);

            }, child: const Text('Already Registered? Login'))
          ],
        ),
      ),
    );
  }
}
