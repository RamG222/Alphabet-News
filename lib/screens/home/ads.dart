//chhotya jahirati page
// ignore_for_file: prefer_const_constructors

import 'package:alphabet/constants.dart';
import 'package:alphabet/models/short_ads_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

final Dio _dio = Dio();
List<ShortAdsModel> shortAdsList = [];

class Ads extends StatefulWidget {
  const Ads({
    super.key,
    required this.t1ID,
    required this.t2ID,
    required this.t3ID,
    required this.t4ID,
    required this.t5ID,
    required this.t1Name,
    required this.t2Name,
    required this.t3Name,
    required this.t4Name,
    required this.t5Name,
  });

  final String? t1ID;
  final String? t2ID;
  final String? t3ID;
  final String? t4ID;
  final String? t5ID;

  final String? t1Name;
  final String? t2Name;
  final String? t3Name;
  final String? t4Name;
  final String? t5Name;

  @override
  State<Ads> createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  void getAPIData() async {
    List<String> idList = [
      if (widget.t1ID != null) widget.t1ID.toString(),
      if (widget.t2ID != null) widget.t2ID.toString(),
      if (widget.t3ID != null) widget.t3ID.toString(),
      if (widget.t4ID != null) widget.t4ID.toString(),
      if (widget.t5ID != null) widget.t5ID.toString(),
    ];
    String idString = idList.join(',');

    try {
      final response =
          await _dio.get('$apiURL/display_shortads.php?ctid=$idString');

      var apiAdsData = response.data['data'] as List;

      setState(() {
        shortAdsList = apiAdsData.map((item) {
          return ShortAdsModel(
            id: item['SAID'],
            title: item['AdTitle'],
            text: item['AdText'],
            mobile1: item['Mobile1'],
            mobile2: item['Mobile2'],
            whatsappNumber: item['Whatsapp'],
          );
        }).toList();
      });
    } catch (e) {
      Get.snackbar('Error1', '$e');
    }
  }

  @override
  void initState() {
    super.initState();
    getAPIData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(56, 216, 215, 215),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'छोट्या जाहिराती',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  var data = shortAdsList[index];
                  return ads_card_widget(data: data);
                },
                itemCount: shortAdsList.length,
                separatorBuilder: (context, index) {
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class ads_card_widget extends StatelessWidget {
  const ads_card_widget({
    super.key,
    required ShortAdsModel data,
  }) : _data = data;

  final ShortAdsModel _data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        height: 145,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text(
                _data.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AutoSizeText(
                  _data.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //
                ElevatedButton(
                  onPressed: () {
                    //
                    Get.snackbar('title', 'Clicked on Photos');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    elevation: 2,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: SizedBox(
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_library_sharp,
                          color: Colors.orangeAccent,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'PHOTOS',
                          style: TextStyle(color: Colors.black, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    //
                    launchUrl(
                      Uri.parse('https://wa.me/+91${_data.whatsappNumber}'),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    elevation: 2,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/whatsapp.png',
                          height: 28,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'WHATSAPP',
                          style: TextStyle(color: Colors.black, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    //
                    launchUrl(
                      Uri.parse('tel:+91${_data.mobile1}'),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    elevation: 2,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: SizedBox(
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.call,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'MOBILE',
                          style: TextStyle(color: Colors.black, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
