import 'package:alphabet/screens/home/home.dart';
import 'package:alphabet/screens/view_news.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:get/get.dart';

class image_slider extends StatelessWidget {
  const image_slider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Carousel(
        animationPageCurve: Curves.easeInOut,
        height: 300,
        autoScrollDuration: const Duration(seconds: 2),
        indicatorBarColor: Colors.transparent,
        indicatorHeight: 0,
        activateIndicatorColor: const Color.fromARGB(186, 255, 255, 255),
        unActivatedIndicatorColor: const Color.fromARGB(255, 196, 186, 186),
        autoScroll: true,
        items: carouselNewsList.map((newsItem) {
          return InkWell(
              onTap: () {
                Get.to(ViewNewsScreen(
                  url: newsItem.newsURL,
                  title: newsItem.title,
                ));
              },
              child: Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      image: DecorationImage(
                        image: NetworkImage(
                          newsItem.imageURL,
                        ),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          //
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black45,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: Colors.black45,
                        padding: const EdgeInsets.all(12.0),
                        child: AutoSizeText(
                          newsItem.title,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 16,
                          maxFontSize: 16,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        }).toList(),
      ),
    );
  }
}
