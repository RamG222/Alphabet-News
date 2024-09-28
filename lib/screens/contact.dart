import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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
                'Contact Us',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                'For inquiries or assistance, please contact us using the information below:\n\n'
                'Contact Information:\n'
                'Email: alphabetnews@gmail.com\n'
                'Phone: 9890155171\n\n'
                'Operating Hours:\n'
                'Our support team is available Monday to Friday, 10:00 AM - 5:00 PM (local time).\n\n'
                'Response Time:\n'
                'We strive to respond to inquiries within 24 hours. Thank you for your patience.',
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
