import 'package:flutter/material.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/components/AppBarBackButton.dart';
import 'package:rentmything/view/splashView/successView.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../res/components/myButton.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help and Support'),
        leading: AppBarBackButton()
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.color1
              ),
            ),
            SizedBox(height: 10.0),
            FAQSection(),
            SizedBox(height: 20.0),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20.0,
                color: AppColors.color1,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ContactInfoSection(),
            SizedBox(height: 20.0),
            FeedbackSection(),
          ],
        ),
      ),
    );
  }
}

class FAQSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How do I reset my password?',
            style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.color1),
          ),
          SizedBox(height: 8.0),
          Text(
            'You can reset your password by navigating to the settings page and selecting the "Reset Password" option.',
            style: TextStyle(color: AppColors.color1),
          ),
          // Add more FAQs as needed
        ],
      ),
    );
  }
}

class ContactInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'For support inquiries, please contact us at:',
          style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.color1),
        ),
        SizedBox(height: 8.0),
        Text(
          'Email: support@chaavie.com',style: TextStyle(color: AppColors.color1),
        ),
        Text(
          'Phone: 808-673-0010',style: TextStyle(color: AppColors.color1),
        ),
      ],
    );
  }
}

class FeedbackSection extends StatelessWidget {
  final String emailAddress = 'support@chaavie.com';
  final String subject = 'Feedback for MyApp';

  @override
  Widget build(BuildContext context) {
    return MyButton(title: "Provide Feedback",
        backgroundColor: AppColors.color1,
        textColor:Colors.white,
        clickme: ()async {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: emailAddress,
            queryParameters: {
              'subject': subject,
            },
          );
          if (await launchUrl(Uri.parse(emailLaunchUri.toString()))) {
            await launchUrl(Uri.parse(emailLaunchUri.toString()));
          } else {
            throw 'Could not launch $emailLaunchUri';
          }
        },);
  }
}

