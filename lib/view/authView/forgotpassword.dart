import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New Password'),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                ),
                Text('Re enter password'),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                ),
                Center(child: ElevatedButton(onPressed: (){}, child: Text('Submit'))),
                Text('Enter OTP'),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
