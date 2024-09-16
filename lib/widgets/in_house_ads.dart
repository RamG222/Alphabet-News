// ignore_for_file: camel_case_types

import 'package:alphabet/models/ads_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class In_House_ads extends StatelessWidget {
  const In_House_ads({
    super.key,
    required this.adData,
  });

  final AdsModel adData;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 360,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              adData.image,
              fit: BoxFit.cover,
              height: 290,
              width: double.infinity,
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 206, 205, 205),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  adData.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      side: BorderSide(width: 2, color: Colors.grey),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await launchUrl(Uri.parse(adData.url));
                    } catch (e) {
                      Get.snackbar(
                        backgroundColor: const Color.fromARGB(255, 245, 78, 78),
                        'Error',
                        e.toString(),
                      );
                    }
                  },
                  child: Text(
                    adData.buttonText,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
