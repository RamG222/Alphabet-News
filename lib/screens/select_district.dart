import 'package:alphabet/models/district_model.dart';
import 'package:alphabet/screens/select_taluka.dart';
import 'package:alphabet/widgets/more_screen_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alphabet/constants.dart';


final _dio = Dio();
List<DistrictModel> districtsList = [];
DistrictModel? select1;
DistrictModel? select2;

class SelectDistrictScreen extends StatefulWidget {
  const SelectDistrictScreen({super.key});

  @override
  State<SelectDistrictScreen> createState() => _SelectDistrictScreenState();
}

class _SelectDistrictScreenState extends State<SelectDistrictScreen> {
  List<DistrictModel> selectedDistricts = [];

  @override
  void initState() {
    super.initState();
    fetchDistricts();
  }

  void fetchDistricts() async {
    try {
      final response = await _dio.get('$apiURL/display_district.php');

      var apiData = response.data['data'] as List;

      setState(() {
        districtsList = apiData.map((item) {
          return DistrictModel(
            name: item['District'],
            id: item['DSTID'],
          );
        }).toList();
      });
    } catch (e) {
      //
    }
  }

  void toggleSelection(DistrictModel district) {
    setState(() {
      if (selectedDistricts.contains(district)) {
        selectedDistricts.remove(district);
      } else if (selectedDistricts.length < 2) {
        selectedDistricts.add(district);
      }

      // Update select1 and select2
      if (selectedDistricts.isNotEmpty) {
        select1 = selectedDistricts.isNotEmpty ? selectedDistricts[0] : null;
      }
      if (selectedDistricts.length > 1) {
        select2 = selectedDistricts[1];
      } else {
        select2 = null;
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
              'Welcome to Alphabet News',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Select up to 2 districts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          districtsList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 8.0, // Horizontal space between items
                      runSpacing: 10.0, // Vertical space between lines
                      children: districtsList.map((district) {
                        final isSelected = selectedDistricts.contains(district);
                        return InkWell(
                          onTap: () => toggleSelection(district),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isSelected
                                      ? Icon(
                                          Icons.check_circle,
                                          color: const Color.fromARGB(
                                              255, 74, 95, 235),
                                        )
                                      : Icon(
                                          Icons.circle,
                                          color: const Color.fromARGB(
                                              143, 158, 158, 158),
                                        ),
                                  SizedBox(width: 2),
                                  Text(
                                    district.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Color.fromARGB(255, 74, 95, 235)
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
            onPressed: () {
              if (selectedDistricts.isNotEmpty) {
                Get.to(() => SelectTalukaScreen(
                      district1: select1!.id,
                      district2: select2?.id,
                    ));
              } else {
                // Show a message if no districts are selected
                Get.snackbar(
                  "Error",
                  "Please select at least one district",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            iconWidget: Icon(null),
            label: 'Next',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
