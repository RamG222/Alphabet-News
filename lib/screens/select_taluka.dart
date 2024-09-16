import 'package:alphabet/models/taluka_model.dart';
import 'package:alphabet/screens/home/homepage_navigator.dart';
import 'package:alphabet/screens/select_district.dart';
import 'package:alphabet/widgets/more_screen_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _dio = Dio();
List<TalukaModel> talukaList = [];

class SelectTalukaScreen extends StatefulWidget {
  const SelectTalukaScreen(
      {super.key, required this.district1, required this.district2});
  final String district1;
  final String? district2;

  @override
  State<SelectTalukaScreen> createState() => _SelectTalukaScreenState();
}

class _SelectTalukaScreenState extends State<SelectTalukaScreen> {
  List<TalukaModel> selectedTalukas = [];

  @override
  void initState() {
    super.initState();
    fetchTalukas();
  }

  void fetchTalukas() async {
    try {
      final _response1 = await _dio.get(
          'https://alphabetapp.in/api/display_taluka.php?DSTID=${widget.district1}');
      var _apiData1 = _response1.data['data'] as List?;

      var _apiData2 = [];
      if (widget.district2 != null) {
        final _response2 = await _dio.get(
            'https://alphabetapp.in/api/display_taluka.php?DSTID=${widget.district2}');
        _apiData2 = _response2.data['data'] as List;
      }

      List<TalukaModel> talukaFrom1 = _apiData1 != null
          ? _apiData1.map((item) {
              return TalukaModel(
                name: item['Taluka'],
                id: item['TLID'],
              );
            }).toList()
          : [];

      List<TalukaModel> talukaFrom2 = _apiData2.map((item) {
        return TalukaModel(
          name: item['Taluka'],
          id: item['TLID'],
        );
      }).toList();

      setState(() {
        talukaList = [...talukaFrom1, ...talukaFrom2];
      });
    } catch (e) {
      // Handle errors if necessary
    }
  }

  void toggleSelection(TalukaModel taluka) {
    setState(() {
      if (selectedTalukas.contains(taluka)) {
        selectedTalukas.remove(taluka);
      } else if (selectedTalukas.length < 5) {
        selectedTalukas.add(taluka);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          const SizedBox(height: 70),
          const Center(
            child: Text(
              'Select up to 5 Talukas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          talukaList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 8.0,
                      runSpacing: 10.0,
                      children: talukaList.map((taluka) {
                        final isSelected = selectedTalukas.contains(taluka);
                        return InkWell(
                          onTap: () => toggleSelection(taluka),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isSelected
                                      ? const Icon(
                                          Icons.check_circle,
                                          color:
                                              Color.fromARGB(255, 74, 95, 235),
                                        )
                                      : const Icon(
                                          Icons.circle,
                                          color: Color.fromARGB(
                                              143, 158, 158, 158),
                                        ),
                                  const SizedBox(width: 2),
                                  Text(
                                    taluka.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? const Color.fromARGB(
                                              255, 74, 95, 235)
                                          : Colors.grey,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
          const SizedBox(height: 20),
          more_screen_button(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();

                pref.setString('isDistrictAndTalukaSelected', 'true');
                pref.setString('district1', select1!.id);
                pref.setString('district2', select2!.id);

                for (int i = 0; i < selectedTalukas.length; i++) {
                  pref.setString('t${i + 1}ID', selectedTalukas[i].id);
                  pref.setString('t${i + 1}Name', selectedTalukas[i].name);
                }

                for (int i = selectedTalukas.length; i < 5; i++) {
                  pref.remove('t${i + 1}ID');
                  pref.remove('t${i + 1}Name');
                }

                Get.offAll(
                  const HomepageNavigator(),
                );
              },
              iconWidget: Icon(null),
              label: 'Finish'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
