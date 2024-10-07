// ignore_for_file: camel_case_types

import 'package:alphabet/models/news_model.dart';
import 'package:alphabet/screens/view_news.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:app_set_id/app_set_id.dart';
import 'package:jiffy/jiffy.dart';

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
              children: [
                SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(2), right: Radius.circular(2)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.network(
                        widget.data.imageURL,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ),
                ),
                // Additional widgets for the news content can be added here
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: AutoSizeText(
                      widget.data.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      minFontSize: 16,
                      maxFontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: AutoSizeText(
                        " ${widget.data.sourceName}    ⏱️ ${Jiffy.parse(widget.data.publishDate).fromNow()}",
                        style: const TextStyle(color: Colors.grey),
                        minFontSize: 12,
                        maxFontSize: 12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Transform.translate(
                          offset: const Offset(35, 0),
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/whatsapp.png',
                              height: 30,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(20, 0),
                          child: const IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(10, 0),
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              widget.data.views,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert_outlined,
                            size: 25,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
