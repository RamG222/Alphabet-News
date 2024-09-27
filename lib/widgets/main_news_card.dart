// ignore_for_file: camel_case_types

import 'package:alphabet/models/news_model.dart';
import 'package:alphabet/screens/view_news.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class main_news_card extends StatelessWidget {
  const main_news_card({
    super.key,
    required this.data,
  });

  final NewsModel data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: InkWell(
        onTap: () {
          Get.to(ViewNewsScreen(
            url: data.newsURL,
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
                        data.imageURL,
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
                      data.title,
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
                        " ${data.sourceName}    ⏱️ ${Jiffy.parse(data.publishDate).fromNow()}",
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
                              data.views,
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
