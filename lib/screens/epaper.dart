import 'package:alphabet/models/epaper_model.dart';
import 'package:alphabet/screens/view_news.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

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
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      d1ID = pref.getString('district1');
      d2ID = pref.getString('district2');
    });
    String combinedIDs;

    if (d2ID != null && d2ID!.isNotEmpty) {
      combinedIDs = '${d1ID ?? 'null'},$d2ID';
    } else {
      combinedIDs = d1ID ?? 'null2';
    }

    // Optionally store or use the combinedIDs string as needed
    // For example, you could assign it to a variable:
    DistIdString = combinedIDs;

    getAPIData();
  }

  void getAPIData() async {
    var response =
        await _dio.get('$apiURL/display_epaper.php?did=$DistIdString');

    var epaperData = response.data['data'] as List;

    setState(() {
      epaperList = epaperData.map((item) {
        return EpaperModel(
            id: item['NEID'],
            name: item['Paper_Name'],
            url: item['Epaper_Link'],
            logo: item['Logo'],
            epaperLink: item['Epaper_Link']);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 231),
      appBar: AppBar(title: Text('E-Paper')),
      body: SafeArea(
        child: epaperList.isEmpty
            ? Center(child: CircularProgressIndicator()) // Loading indicator
            : ListView.builder(
                itemCount: epaperList.length,
                itemBuilder: (context, index) {
                  var data = epaperList[index];
                  return InkWell(
                    onTap: () {
                      Get.to(() => ViewNewsScreen(url: data.epaperLink));
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            data.logo.toString(),
                            height: 70,
                            width: 80,
                            fit: BoxFit.fill,
                          ),
                        ), // Use logo instead of url for the image
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Read News by clicking here'),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
