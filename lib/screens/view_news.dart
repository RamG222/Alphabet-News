import 'package:alphabet/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';

WebViewController controller = WebViewController();

class ViewNewsScreen extends StatefulWidget {
  const ViewNewsScreen({super.key, required this.url, required this.title});
  final String url;
  final String title;

  @override
  State<ViewNewsScreen> createState() => _ViewNewsScreenState();
}

class _ViewNewsScreenState extends State<ViewNewsScreen> {
  // ignore: unused_field
  bool _isloading = true;

  // Separate instances for two BannerAd objects
  BannerAd? bannerAd1;
  BannerAd? bannerAd2;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains(widget.url)) {
              return NavigationDecision.navigate;
            } else {
              return NavigationDecision.prevent;
            }
          },
          onProgress: (progress) {},
          onPageFinished: (url) {
            setState(() {
              _isloading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    // Load both ads separately
    loadBannerAd1();
    loadBannerAd2();
  }

  //dialog ads
  void loadBannerAd1() {
    bannerAd1 = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            bannerAd1 = ad as BannerAd?;
            // Show ad dialog once this ad is loaded
            showAdDialog(context);
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadBannerAd2() {
    bannerAd2 = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            bannerAd2 = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void showAdDialog(BuildContext context) {
    if (bannerAd1 != null) {
      showDialog(
        useSafeArea: true,
        context: context,
        barrierDismissible: false, // Prevent accidental dismissal
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors
                .transparent, // Make background transparent for custom styling
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Ad background color
                borderRadius: BorderRadius.circular(16), // Rounded corners
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 5), // Shadow effect
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16), // Padding inside the container
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  // Ad widget container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        12), // Rounded corners for the ad itself
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: AdWidget(ad: bannerAd1!),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Close button with elevated style
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Button background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: WebViewWidget(controller: controller),
            ),
            if (bannerAd2 != null) // Check if the second banner ad is loaded
              SizedBox(
                height: 50,
                child: AdWidget(ad: bannerAd2!),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose both banner ads when the widget is disposed
    bannerAd1?.dispose();
    bannerAd2?.dispose();
    super.dispose();
  }
}
