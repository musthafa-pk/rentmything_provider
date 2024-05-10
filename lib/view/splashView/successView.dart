import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/view/bottomNavigationPage.dart';

class SuccessView extends StatefulWidget {
  const SuccessView({super.key});


  @override
  State<SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView> {
  @override
  void initState() {
    // TODO: implement initState
    // Add a delay before navigating to the home page
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavigationPage(),), (route) => false);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
      // );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Success...',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 28,color: AppColors.color1),),
            Image.asset('assets/images/success_image.jpg'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left:25.0,right: 25.0),
                  child: Text('Step back and relax. Your ad \n      is under verification.',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    color: AppColors.color1
                  ),),),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 25,right: 25),
            //   child: Column(
            //     children: [
            //       MyButton(clickme: () {
            //
            //       },title: 'Go to Ad Section',backgroundColor: Colors.white,textColor: AppColors.color1,),
            //       SizedBox(height: 10.0,),
            //       MyButton(clickme: () {
            //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage(),));
            //       },title: 'Back to Home',backgroundColor: AppColors.color1,textColor: Colors.white, ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
