import 'package:alphabet/screens/home/home.dart';
import 'package:alphabet/screens/view_news.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class old_card extends StatelessWidget {
  const old_card({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        if (index > 0 && index % 3 == 0) {
          // your ad goes here
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 150,
            color: Colors.blueAccent,
            child: Center(
                child: Text(
              'AD here',
              style: TextStyle(color: Colors.white, fontSize: 40),
            )),
          );
        }
        return Container();
      },
      shrinkWrap: true, // This makes the ListView take the minimum height
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 22,
      itemBuilder: (context, index) {
        var data2 = mainNewsList[index];
        return InkWell(
          onTap: () {
            Get.to(ViewNewsScreen(
              url: data2.newsURL,
            ));
          },
          child: Card(
            child: Column(
              children: [
                Container(
                  height: 150,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            data2.imageURL,
                            height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const SizedBox(height: 5),
                            Expanded(
                              child: AutoSizeText(
                                data2.title,
                                style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 3,
                                maxFontSize: 18,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  color: const Color.fromARGB(102, 0, 174, 255),
                                  child: AutoSizeText(
                                    Jiffy.parse(data2.publishDate).fromNow(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        tooltip: 'Share To whatsapp',
                                        icon: Image.asset(
                                          'assets/whatsapp.png',
                                          height: 30,
                                        )),
                                    IconButton(
                                      tooltip: 'Share',
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.share,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
