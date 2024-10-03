import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Privacy Policy',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  'Please read this Privacy Policy very carefully. This contains important information about Your rights and obligations. This Privacy Policy sets out the manner in which Alphabet News collects, uses, maintains and discloses information collected from the Users of our mobile application (hereinafter referred to as \'You\', \'Your\', \'User\'). This Privacy Policy applies to the usage of Alphabet News App which is owned by Alphabet News company. By downloading, installing or using this App, You are consenting to the use of Your personal information in the manner set out in this Privacy policy. By downloading, installing or using this App or by registering Your profile with Alphabet News You are consenting to the collection, storage, transfer, disclosure and other uses of Your information as set out in this Privacy Policy.\n\n'
                  'This Privacy Policy does not apply to the practices of third parties that Alphabet News does not own, control, or manage including but not limited to any third party websites, services, applications, or businesses. Alphabet News does not take responsibility for the content or privacy policies of those Third Party services.\n\n'
                  'If You do not agree to any of the provisions of this Privacy Policy, You should not download, install and use the App. Alphabet News may revise, alter, add, amend or modify this Privacy Policy at any time by updating this page. By downloading, installing and/or using this App, You agree to be bound by any such alteration, amendment, addition or modification.',
                  style: TextStyle(
                    fontSize: 16, // Adjust the font size as needed
                    color: Colors.black, // Change the text color if desired
                  ),
                  textAlign: TextAlign
                      .justify, // Justify the text for better readability
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
