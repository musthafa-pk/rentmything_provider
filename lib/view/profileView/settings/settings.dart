import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentmything/main.dart';
import 'package:rentmything/res/app_colors.dart';
import 'package:rentmything/res/components/profileTabs.dart';
import 'package:rentmything/utils/utls.dart';
import 'package:rentmything/view/authView/loginScreen.dart';
import 'package:rentmything/view/profileView/settings/resetPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveThemePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  // Method to show a confirmation dialog for deleting the account
  Future<void> _showDeleteAccountConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account',style: TextStyle(color: AppColors.color1),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete your account? Continuing this step will permanently remove your account, and you won\'t be able to create a new one with these credentials.',
                style: TextStyle(color: AppColors.color1),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: TextStyle(color: AppColors.color1),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete',style: TextStyle(color: AppColors.color1),),
              onPressed: () {
                // Implement the logic to delete the account here
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to delete the user's account
  void _deleteAccount() {
    // Implement the logic to delete the account here
    // For example, you can make an API call to delete the account
    // After successfully deleting the account, navigate to the login screen or any other appropriate screen
    // You can also show a confirmation message to the user
    // For demonstration purposes, I'll just navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left, color: AppColors.color1,size: 35,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Settings', style: TextStyle(color: AppColors.color1)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                'Display',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  color: AppColors.color1
                ),
              ),
              SizedBox(height: 20),
              CupertinoFormRow(
                child: Text('Dark Mode',style: TextStyle(color: AppColors.color1),),
                prefix: CupertinoSwitch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                      context.read<ThemeProvider>().isDarkMode = value;
                      _saveThemePreference(value);
                    });
                  },
                ),
              ),
              Divider(),
              SizedBox(height: 20),
              Text(
                'Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.color1),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPassword()),
                  );
                },
                child: ListTile(
                  title: Text('Reset Password',style: TextStyle(color: AppColors.color1),),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.color1),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Show the confirmation dialog when the user taps on "Delete Account"
                  _showDeleteAccountConfirmationDialog();
                },
                child: ListTile(
                  title: Text('Delete Account',style: TextStyle(color: AppColors.color1),),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.color1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
