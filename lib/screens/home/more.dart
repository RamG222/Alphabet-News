import 'package:alphabet/screens/Terms_conditions.dart';
import 'package:alphabet/screens/contact.dart';
import 'package:alphabet/screens/epaper.dart';
import 'package:alphabet/screens/privacy_policy.dart';
import 'package:alphabet/screens/select_district.dart';
import 'package:alphabet/screens/view_news.dart';
import 'package:alphabet/widgets/more_screen_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 231),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Alphabet News',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                const SizedBox(height: 10),
                more_screen_button(
                  iconWidget: Icon(Icons.newspaper_outlined),
                  label: 'E-Paper',
                  onPressed: () {
                    Get.to(
                      EpaperScreeen(),
                    );
                  },
                ),
                more_screen_button(
                  iconWidget: Icon(Icons.settings_outlined),
                  label: 'Change Taluka and District',
                  onPressed: () {
                    Get.to(SelectDistrictScreen());
                  },
                ),
                more_screen_button(
                  iconWidget: Icon(Icons.share_outlined),
                  label: 'Share App',
                  onPressed: () {
                    launchUrl(
                      Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.stormsofts.alphabetnews'),
                    );
                  },
                ),
              ],
            ),
            Column(
              children: [
                more_screen_button(
                  iconWidget: Icon(Icons.privacy_tip_outlined),
                  label: 'Privacy Policy',
                  onPressed: () {
                    Get.to(() => PrivacyPolicyScreen());
                  },
                ),
                more_screen_button(
                  iconWidget: Icon(Icons.assignment_turned_in_outlined),
                  label: 'Terms & Conditions',
                  onPressed: () {
                    Get.to(() => TermsConditionsScreen());
                  },
                ),
                more_screen_button(
                  iconWidget: Icon(Icons.assignment_turned_in_outlined),
                  label: 'FAQ',
                  onPressed: () {
                    Get.to(
                      () =>
                          ViewNewsScreen(url: 'https://alphabetapp.in/faq.php'),
                    );
                  },
                ),
                more_screen_button(
                  iconWidget: Icon(Icons.assignment_turned_in_outlined),
                  label: 'Contact Us',
                  onPressed: () {
                    Get.to(() => ContactScreen());
                  },
                ),
                SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
