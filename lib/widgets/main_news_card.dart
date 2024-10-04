// ignore_for_file: camel_case_types

import 'package:alphabet/models/news_model.dart';
import 'package:alphabet/screens/view_news.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:app_set_id/app_set_id.dart';

final dio = Dio();

class MainNewsCard extends StatefulWidget {
  const MainNewsCard({
    super.key,
    required this.data,
  });

  final NewsModel data;

  @override
  _MainNewsCardState createState() => _MainNewsCardState();
}

class _MainNewsCardState extends State<MainNewsCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appSetId = await AppSetId().getIdentifier();

      increaseImpressionCount(
          widget.data.newsID, appSetId!); // Pass your userID
    });
  }

  void increaseImpressionCount(String newsID, String userID) async {
    print('Increasing impression count for newsID: $newsID, userID: $userID');
    await dio.get(
      'https://alphabetapp.in/api/insert_views.php?newsid=$newsID&UID=$userID',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: InkWell(
        onTap: () {
          Get.to(ViewNewsScreen(
            url: widget.data.newsURL,
          ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Card(
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(2)),
            color: const Color.fromARGB(236, 255, 255, 255),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(widget.data.imageURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.data.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                // News Source and Date Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.data.sourceName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.data.publishDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Views Count Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.remove_red_eye,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.data.views} views',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
