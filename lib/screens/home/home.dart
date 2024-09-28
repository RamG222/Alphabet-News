import 'package:alphabet/constants.dart';
import 'package:alphabet/models/ads_model.dart';
import 'package:alphabet/models/category_model.dart';
import 'package:alphabet/models/horizontal_list_view.dart';
import 'package:alphabet/models/news_model.dart';
import 'package:alphabet/widgets/custom_sliver.dart';
import 'package:alphabet/widgets/image_slider.dart';
import 'package:alphabet/widgets/in_house_ads.dart';
import 'package:alphabet/widgets/main_news_card.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final dio = Dio();
List<CategoryModel> categoryList = [];
List<NewsModel> mainNewsList = [];
List<NewsModel> carouselNewsList = [];
List<AdsModel> adsList = [];

List<HorizontalListView> horizontalList = [
  HorizontalListView(
    name: 'ALL',
    id: '1',
    isTaluka: "false",
  ),
];

String _selectedTabIndex = '0';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pagination = 1;

  bool showButton = false;

  final List<BannerAd?> _ads = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeScroller();
    getNews();
    loadGoogleAds(10);
    getCategories();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var ad in _ads) {
      ad?.dispose();
    }
    super.dispose();
  }

  void initializeScroller() {
    _scrollController.addListener(() {
      // Determine if the button should be visible based on the scroll position
      if (_scrollController.offset > 300) {
        // Adjust this value to change when the button appears
        if (!showButton) {
          setState(() {
            showButton = true;
          });
        }
      } else {
        if (showButton) {
          setState(() {
            showButton = false;
          });
        }
      }

      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (!isTop) {
          // Bottom of the list
          setState(() {
            pagination++;
            getNews();
            showButton = true;
          });
        }
      }
    });
  }

  void loadGoogleAds(int count) {
    for (int i = 0; i < count; i++) {
      BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: adUnitId,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _ads.add(ad as BannerAd?);
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
      ).load();
    }
  }

  void getAds() async {
    List<String> idList = [
      if (widget.t1ID != null) widget.t1ID.toString(),
      if (widget.t2ID != null) widget.t2ID.toString(),
      if (widget.t3ID != null) widget.t3ID.toString(),
      if (widget.t4ID != null) widget.t4ID.toString(),
      if (widget.t5ID != null) widget.t5ID.toString(),
    ];
    String idString = idList.join(',');

    try {
      final response = await dio.get(
          'https://alphabetapp.in/api/display_ads.php?ctid=$idString&adtid=2');

      var apiAdsData = response.data['data'] as List;

      setState(() {
        adsList = apiAdsData.map((item) {
          return AdsModel(
            id: item['AdId'],
            name: item['AdTitle'],
            image: item['Ad_Image'],
            url: item['AdLink'],
            buttonText: item['AdLinkTitle'],
          );
        }).toList();
      });
    } catch (e) {
      Get.snackbar('Error1', '$e');
    }
  }

  Future<void> getNews() async {
    String apiUrl = '';
    await Future.delayed(const Duration(seconds: 1));

    List<String> idList = [
      if (widget.t1ID != null) widget.t1ID.toString(),
      if (widget.t2ID != null) widget.t2ID.toString(),
      if (widget.t3ID != null) widget.t3ID.toString(),
      if (widget.t4ID != null) widget.t4ID.toString(),
      if (widget.t5ID != null) widget.t5ID.toString(),
    ];

    String cityIdString = idList.isNotEmpty ? idList.join(',') : '1';

    if (horizontalList[int.parse(_selectedTabIndex)].isTaluka == 'true') {
      //if taluka
      setState(() {
        apiUrl =
            'https://alphabetapp.in/api/display_city_wise_news_pagination.php?ctid=${horizontalList[int.parse(_selectedTabIndex)].id}&page=$pagination';
      });
    } else {
      // else category
      if (horizontalList[int.parse(_selectedTabIndex)].id == "1") {
        setState(() {
          apiUrl =
              'https://alphabetapp.in/api/display_news_pagination.php?catid=${horizontalList[int.parse(_selectedTabIndex)].id}&ctid=$cityIdString&page=$pagination';
        });
      } else {
        setState(() {
          apiUrl =
              'https://alphabetapp.in/api/display_news_pagination.php?catid=${horizontalList[int.parse(_selectedTabIndex)].id}&ctid=$cityIdString&page=$pagination';
        });
      }
    }

    final response = await dio.get(apiUrl);
    var apiData2 = response.data['data'] as List;

    setState(() {
      if (pagination == 1) {
        mainNewsList = apiData2.map((item) {
          return NewsModel(
            item['NSID'],
            item['News_Head'],
            item['News_Image'],
            item['News_Link'],
            item['Publish_Date'],
            item['source'],
            item['Views'],
          );
        }).toList();
      } else {
        mainNewsList.addAll(apiData2.map((item) {
          return NewsModel(
            item['NSID'],
            item['News_Head'],
            item['News_Image'],
            item['News_Link'],
            item['Publish_Date'],
            item['source'],
            item['Views'],
          );
        }).toList());
      }
    });

    final response_featured =
        await dio.get('https://alphabetapp.in/api/display_slider.php');
    setState(() {
      final apifeaturedData = response_featured.data['data'] as List;

      carouselNewsList = apifeaturedData.map((item) {
        return NewsModel(
          item['NSID'],
          item['News_Head'],
          item['News_Image'],
          item['News_Link'],
          item[
              'NSID'], // Assuming you want to pass the same value multiple times
          item[
              'NSID'], // If these are supposed to be different values, use appropriate keys
          item['NSID'],
        );
      }).toList(); // Convert the Iterable to a List
    });

    getAds();
  }

  void getCategories() async {
    categoryList.clear();
    final response =
        await dio.get('https://alphabetapp.in/api/display_category.php');

    var apiData = response.data['data'] as List;

    setState(() {
      categoryList = apiData.map((json) {
        return CategoryModel(
            json['Category'], json['CGID'], json['Cat_Imageurl']);
      }).toList();
    });

    populateHorizontalList();
  }

  void populateHorizontalList() {
    setState(() {
      if (widget.t1ID != null && widget.t1Name != null) {
        horizontalList.add(HorizontalListView(
          id: widget.t1ID!,
          name: widget.t1Name!,
          isTaluka: "true",
        ));
      }
      if (widget.t2ID != null && widget.t2Name != null) {
        horizontalList.add(HorizontalListView(
          id: widget.t2ID!,
          name: widget.t2Name!,
          isTaluka: "true",
        ));
      }
      if (widget.t3ID != null && widget.t3Name != null) {
        horizontalList.add(HorizontalListView(
          id: widget.t3ID!,
          name: widget.t3Name!,
          isTaluka: "true",
        ));
      }
      if (widget.t4ID != null && widget.t4Name != null) {
        horizontalList.add(HorizontalListView(
          id: widget.t4ID!,
          name: widget.t4Name!,
          isTaluka: "true",
        ));
      }
      if (widget.t5ID != null && widget.t5Name != null) {
        horizontalList.add(HorizontalListView(
          id: widget.t5ID!,
          name: widget.t5Name!,
          isTaluka: "true",
        ));
      }

      for (var category in categoryList) {
        horizontalList.add(
          HorizontalListView(
            name: category.name,
            id: category.catID,
            isTaluka: "false",
          ),
        );
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      pagination = 1; // Reset pagination for refresh
      mainNewsList.clear(); // Clear existing news
      carouselNewsList.clear(); // Clear existing carousel news
    });
    await getNews(); // Fetch new data
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: !showButton
            ? null
            : FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 187, 220, 247),
                onPressed: () {
                  _scrollController.animateTo(
                    0, // Scroll to the top
                    duration: const Duration(
                        milliseconds: 500), // Duration of the scroll
                    curve: Curves.easeInOut, // Scroll animation curve
                  );
                  setState(() {
                    showButton = false;
                  });
                },
                child: const Icon(
                  Icons.arrow_upward,
                  size: 30,
                  color: Colors.blue,
                ),
              ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          color: Colors.blueAccent,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController, // Attach ScrollController

            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Image Slider Section
              SliverToBoxAdapter(
                child: carouselNewsList.isEmpty
                    ? const SizedBox(height: 300)
                    : const SizedBox(
                        height: 300,
                        child: image_slider(),
                      ),
              ),

              // Horizontal List Section (Persistent Header)
              SliverPersistentHeader(
                pinned: true, // Keeps the header pinned at the top
                floating: true, // Allows it to float while scrolling
                delegate: SliverAppBarDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    color: const Color.fromARGB(255, 232, 231, 231),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(2),
                      scrollDirection: Axis.horizontal,
                      itemCount: horizontalList.length,
                      itemBuilder: (context, index) {
                        var data = horizontalList[index];
                        return TextButton(
                          onPressed: () {
                            setState(() {
                              mainNewsList.clear();
                              carouselNewsList.clear();
                              _selectedTabIndex = index.toString();
                              pagination = 1; // Reset pagination for new tab
                              getNews();
                            });
                          },
                          child: Text(
                            data.name,
                            style: TextStyle(
                              fontSize: 18,
                              color: _selectedTabIndex == index.toString()
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Main News List Section
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Show CircularProgressIndicator only at the end if there are no more items to load
                    if (index == mainNewsList.length) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                      );
                    }

                    // Calculate positions based on repeating pattern
                    int adjustedIndex = index;
                    int adPosition = 3;
                    int adWidgetPosition = 7;

                    // Check if the index is for an ad or a special widget
                    if (adjustedIndex % 8 == adPosition) {
                      // 4th widget is In_House_ads
                      return In_House_ads(
                        adData: adsList[(adjustedIndex ~/ 8) % adsList.length],
                      );
                    } else if (adjustedIndex % 8 == adWidgetPosition &&
                        _ads.isNotEmpty) {
                      // 8th widget is AdWidget
                      return Container(
                        height: 300,
                        color: Colors.white,
                        child: AdWidget(
                            ad: _ads[(adjustedIndex ~/ 8) % _ads.length]!),
                      );
                    } else {
                      // For all other indices, return the main_news_card widget
                      if (index < mainNewsList.length) {
                        return main_news_card(data: mainNewsList[index]);
                      }
                    }
                    return const SizedBox
                        .shrink(); // Avoid showing anything if index is out of bounds
                  },
                  childCount: mainNewsList.length +
                      1, // Add 1 for the CircularProgressIndicator
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
