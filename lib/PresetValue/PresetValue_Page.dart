import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Footer/Footer_presetValue.dart';
import '../Shared/drawer.dart';
import 'PresetValue_Controller.dart';

class PresetvaluePage extends StatelessWidget {
  final presetcontrol = Get.find<PresetvalueController>(); // Get the controller

  final RxString dropdownValue = 'Price'.obs; // Observable dropdown value

  // Dropdown options
  final List<String> dropdownOptions = ['Price', 'Liter'];

  // Price and Liter card values

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2B2B2B),
        appBar: const CustomAppBar(),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                if (presetcontrol.customController.issupervisormaiar.value)
                  buildStandardRow() // Show only input and dropdown
                else ...[
                  buildInputRow(),
                  const SizedBox(height: 30),
                  Obx(
                    () => Column(
                      children: List.generate(presetcontrol.cardValues.length,
                          (index) {
                        return Column(
                          children: [
                            buildCardRow(
                              context,
                              presetcontrol.cardValues[index],
                              'media/money.png',
                              presetcontrol.cardValues[index] == 'Full Tank',
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        bottomNavigationBar: FooterPresetValue(),
      ),
    );
  }

  Widget buildCardRow(
      BuildContext context, String text, String imagePath, bool isFullTank) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [buildCard(text, imagePath, isFullTank, context)],
    );
  }

  Widget buildCard(
      String text, String imagePath, bool isFullTank, BuildContext context) {
    Color cardColor = isFullTank
        ? const Color(0xFF176E38)
        : const Color.fromARGB(255, 24, 24, 24);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          presetcontrol.showExtractedValuesPopup(context);
          presetcontrol.value = isFullTank ? '9999.9' : text;
        },
        child: Card(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Icon(
                        Icons.payments_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '${(text).tr}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Card(
              color: const Color.fromARGB(255, 24, 24, 24),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Obx(
                  () => DropdownButton<String>(
                    value: dropdownValue.value,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    iconSize: 40,
                    underline: Container(),
                    dropdownColor: const Color.fromARGB(255, 24, 24, 24),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    items: dropdownOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: (value),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50.0),
                          child: Text(value.tr,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      presetcontrol.updatedropdown(newValue!);
                      dropdownValue.value = newValue!;
                      updateCardValues(newValue);
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              color: const Color(0xFF176E38),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: presetcontrol.presetvalueController,
                  decoration: InputDecoration(
                    hintText: 'Enter_number'.tr,
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                    filled: true,
                    fillColor: Color(0xFF176E38),
                    border: InputBorder.none,
                  ),
                  enabled: !presetcontrol.isInputDisabled.value,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    presetcontrol.updateValue();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStandardRow() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Card(
            color: const Color.fromARGB(255, 24, 24, 24),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0),
              child: Container(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                  ),
                  child: Text(
                    ("Liter").tr,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            color: const Color(0xFF176E38),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                controller: presetcontrol.presetvalueController,
                decoration: const InputDecoration(
                  hintText: '20',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                  filled: true,
                  fillColor: Color(0xFF176E38),
                  border: InputBorder.none,
                ),
                enabled: !presetcontrol.isInputDisabled.value,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                // onChanged: (value) {
                //   presetcontrol.updateValue();
                // },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void updateCardValues(String dropdownSelection) {
    if (dropdownSelection == 'Price') {
      presetcontrol.cardValues.value = [
        ' ' + ('Full_Tank').tr,
        '200' + '' + ('EGP').tr,
        '150' + '' + ('EGP').tr,
        '100' + '' + ('EGP').tr
      ];
    } else if (dropdownSelection == 'Liter') {
      presetcontrol.cardValues.value = [
        ' ' + ('Full_Tank').tr,
        ' ' + '30' + ' ' + ('LTR').tr,
        ' ' + '15' + ' ' + ('LTR').tr,
        ' ' + '5' + ' ' + ('LTR').tr
      ];
    }
  }
}
