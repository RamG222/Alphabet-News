import 'package:alphabet/constants.dart';
import 'package:alphabet/models/rashi_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

List<RashiModel> rashi = [];
final Dio _dio = Dio();
BannerAd? _currentAd;
bool isLoading = true;

class RashiScreen extends StatefulWidget {
  const RashiScreen({super.key});

  @override
  State<RashiScreen> createState() => _RashiScreenState();
}

class _RashiScreenState extends State<RashiScreen> {
  String selectedDescription = '';
  int selectedIndex = 0; // Track the selected index

  @override
  void initState() {
    super.initState();
    getAPIData();
    loadNewAd(); // Load the first ad
  }

  void loadNewAd() {
    // Dispose of the current ad before loading a new one

    // Load a new ad
    _currentAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _currentAd = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    setState(() {
      _currentAd?.load();
    });
  }

  // Method to fetch API data
  void getAPIData() async {
    try {
      final response = await _dio.get('$apiURL/display_rashi.php');
      var _apiAdsData = response.data['data'] as List;

      setState(() {
        rashi = _apiAdsData.map((item) {
          return RashiModel(
            id: item['RSHID'],
            name: item['Rashi'],
            description: item['Descp'],
            imageURL: item['Rashi_img'],
            publishDate: item['P_date'],
          );
        }).toList();

        // Set default description to the first item's description
        selectedDescription = rashi[0].description;
        isLoading = false;
      });
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }

  void handleVerticalSwipe(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      // Swipe up to go to the next item
      setState(() {
        selectedIndex = (selectedIndex + 1) % rashi.length;
        selectedDescription = rashi[selectedIndex].description;
      });
    } else if (details.primaryVelocity! > 0) {
      // Swipe down to go to the previous item
      setState(() {
        selectedIndex = (selectedIndex - 1 + rashi.length) % rashi.length;
        selectedDescription = rashi[selectedIndex].description;
      });
    }

    // Refresh ad after swipe
    loadNewAd();
  }

  @override
  void dispose() {
    // Dispose of the ad when the widget is disposed
    _currentAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GestureDetector(
                onVerticalDragEnd:
                    handleVerticalSwipe, // Detect vertical swipe gestures
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: const Text(
                        'राशी भविष्य',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      pinned: false,
                      backgroundColor: Colors.white,
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: rashi.length,
                          itemBuilder: (context, index) {
                            var _data = rashi[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _currentAd?.dispose();
                                  loadNewAd();

                                  selectedIndex =
                                      index; // Update the selected index
                                  selectedDescription = _data
                                      .description; // Update description on tap
                                });
                              },
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        color: const Color.fromARGB(
                                            255, 232, 231, 231),
                                        padding: const EdgeInsets.all(12.0),
                                        child: AutoSizeText(
                                          _data.name,
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: selectedIndex == index
                                                ? Colors.red
                                                : Colors.black,
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
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Image.network(
                              rashi[selectedIndex].imageURL,
                              width: 100,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              rashi[selectedIndex].name,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Divider(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Text(
                            selectedDescription.isNotEmpty
                                ? selectedDescription
                                : 'Please select a Rashi to see the Horoscope',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_currentAd != null)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: AdWidget(ad: _currentAd!),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
