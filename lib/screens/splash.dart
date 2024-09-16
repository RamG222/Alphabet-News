import 'package:alphabet/screens/home/homepage_navigator.dart';
import 'package:alphabet/screens/select_district.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkisLoggedIn();
  }

  void checkisLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 1));

    final String? isDistrictAndTalukaSelected =
        prefs.getString('isDistrictAndTalukaSelected');

    if (isDistrictAndTalukaSelected == "true") {
      Get.offAll(
        () => const HomepageNavigator(),
      );
    } else {
      Get.offAll(
        () => const SelectDistrictScreen(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image.asset(
        'assets/splash.png',
        fit: BoxFit.cover,
      )),
    );
  }
}
