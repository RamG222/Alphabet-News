import 'package:alphabet/models/epaper_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? d1ID;
String? d2ID;
String? DistIdString;

List<EpaperModel> epaperList = [];

final _dio = Dio();

class EpaperScreeen extends StatefulWidget {
  const EpaperScreeen({super.key});

  @override
  State<EpaperScreeen> createState() => _EpaperScreeenState();
}

class _EpaperScreeenState extends State<EpaperScreeen> {
  @override
  void initState() {
    super.initState();
    getSharedPrefData();
  }

  void getSharedPrefData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      d1ID = pref.getString('distric1');
      d2ID = pref.getString('distric2');
    });
    String combinedIDs;

    if (d2ID != null && d2ID!.isNotEmpty) {
      combinedIDs = '${d1ID ?? ''},${d2ID}';
    } else {
      combinedIDs = d1ID ?? '';
    }

    // Optionally store or use the combinedIDs string as needed
    // For example, you could assign it to a variable:
    DistIdString = combinedIDs;

    getAPIData();
  }

  void getAPIData() async {
    var response = await _dio
        .get('https://alphabetapp.in/api/display_epaper.php?did=$DistIdString');

    var epaperData = response.data['data'] as List;

    setState(() {
      epaperList = epaperData.map((item) {
        return EpaperModel(
          id: item['NEID'],
          name: item['Paper_Name'],
          url: item['Epaper_Link'],
          logo: item['Logo'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 231),
      body: SafeArea(
          child: ListView.builder(
        itemCount: epaperList.length,
        itemBuilder: (context, index) {
          var _data = epaperList[index];
          return Container();
        },
      )),
    );
  }
}
