import 'package:alphabet/screens/home/ads.dart';
import 'package:alphabet/screens/home/home.dart';
import 'package:alphabet/screens/home/more.dart';
import 'package:alphabet/screens/home/rashi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? t1ID;
String? t2ID;
String? t3ID;
String? t4ID;
String? t5ID;

String? t1Name;
String? t2Name;
String? t3Name;
String? t4Name;
String? t5Name;


class HomepageNavigator extends StatefulWidget {
  const HomepageNavigator({super.key});

  @override
  State<HomepageNavigator> createState() => _HomepageNavigatorState();
}

class _HomepageNavigatorState extends State<HomepageNavigator> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getTalukaFromSharedPrefs();
  }

  void getTalukaFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      t1ID = pref.getString('t1ID');
      t2ID = pref.getString('t2ID');
      t3ID = pref.getString('t3ID');
      t4ID = pref.getString('t4ID');
      t5ID = pref.getString('t5ID');
      t1Name = pref.getString('t1Name');
      t2Name = pref.getString('t2Name');
      t3Name = pref.getString('t3Name');
      t4Name = pref.getString('t4Name');
      t5Name = pref.getString('t5Name');

  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color.fromARGB(255, 0, 174, 255)
              .withOpacity(0.2), // Subtle highlight for selected item
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  color: Color.fromARGB(255, 0, 174, 255),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                );
              }
              return const TextStyle(
                color: Color.fromARGB(255, 34, 34, 34),
                fontSize: 12,
              );
            },
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          height: 70,
          onDestinationSelected: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          selectedIndex: currentIndex,
          destinations: [
            _buildNavigationDestination(
              icon: Icons.home_filled,
              label: 'Home',
              index: 0,
            ),
            _buildNavigationDestination(
              icon: Icons.ads_click_outlined,
              label: 'छोट्या जाहिराती',
              index: 1,
            ),
            _buildNavigationDestination(
              icon: Icons.sunny,
              label: 'राशी भविष्य',
              index: 2,
            ),
            _buildNavigationDestination(
              icon: Icons.more_horiz,
              label: 'More',
              index: 3,
            ),
          ],
        ),
      ),
      body: <Widget>[
        HomeScreen(
          t1ID: t1ID,
          t2ID: t2ID,
          t3ID: t3ID,
          t4ID: t4ID,
          t5ID: t5ID,
          t1Name: t1Name,
          t2Name: t2Name,
          t3Name: t3Name,
          t4Name: t4Name,
          t5Name: t5Name,
        ),
        Ads(
          t1ID: t1ID,
          t2ID: t2ID,
          t3ID: t3ID,
          t4ID: t4ID,
          t5ID: t5ID,
          t1Name: t1Name,
          t2Name: t2Name,
          t3Name: t3Name,
          t4Name: t4Name,
          t5Name: t5Name,
        ),
        const RashiScreen(),
        const MoreScreen(),
      ][currentIndex],
    );
  }

  NavigationDestination _buildNavigationDestination({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return NavigationDestination(
      icon: AnimatedScale(
        scale: currentIndex == index ? 1.2 : 1.0, // Scale animation for icon
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Icon(
          icon,
          color: currentIndex == index
              ? const Color.fromARGB(255, 0, 174, 255)
              : const Color.fromARGB(
                  255, 150, 150, 150), // Softer color for unselected state
        ),
      ),
      label: label,
    );
  }
}
