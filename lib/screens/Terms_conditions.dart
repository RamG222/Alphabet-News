import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                'Content Ownership: The news articles, images, and other content provided in this app are owned by the respective content creators and publishers.\n\n'
                'User Responsibilities: Users are responsible for the accuracy and legality of the information they share or contribute through the app.\n\n'
                'Privacy Policy: User data is handled according to our privacy policy. Users are encouraged to review the privacy policy to understand how their information is collected, used, and stored.\n\n'
                'Usage Restrictions: Users must adhere to community guidelines and refrain from engaging in activities that violate local laws or infringe upon the rights of others.',
                style: TextStyle(
                  fontSize: 16, // Adjust the font size as needed
                  color: Colors.black, // Change the text color if desired
                ),
                textAlign: TextAlign
                    .justify, // Justify the text for better readability
              )
            ],
          ),
        ),
      ),
    );
  }
}
