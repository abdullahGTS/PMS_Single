import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Footer/Footer_Nozzles.dart';
import '../Shared/drawer.dart';
import 'Nozzles_Controller.dart';

class NozzelsPage extends StatelessWidget {
  NozzelsPage({super.key});
  final nozzelcontroller = Get.find<NozzelsController>();
  final customcontroll = Get.find<CustomAppbarController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Retrieve the pumpnum passed as an argument
    final Map<String, String> arguments = (Get.arguments is Map<String, String>)
        ? Get.arguments as Map<String, String>
        : {'pumpName': 'Unknown'};

// Now you can access the pumpName safely
    final String pumpnum = arguments['pumpName'] ?? 'Unknown';
    print("pumpnumpumpnum: $pumpnum");

    // Extract the pump details from the config
    var pumpData = customcontroll.config['pumps'].firstWhere(
        (pump) => pump['pump_number'].toString() == pumpnum,
        orElse: () => null);

    if (pumpData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF2B2B2B),
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: Center(child: Text("Pump not found")),
        bottomNavigationBar: FooterNozzlesView(),
      );
    }

    List nozzles = pumpData['nozzles'];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2B2B2B),
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Dynamically build a row for nozzles in this pump
                if (nozzles.isNotEmpty)
                  buildNozzlesRow(context, pumpnum, nozzles),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: FooterNozzlesView(),
      ),
    );
  }

  // Method to create a row with nozzles for the given pump
// Updated method to use GridView for responsive layout
  Widget buildNozzlesRow(BuildContext context, String pumpName, List nozzles) {
    return GridView.builder(
      shrinkWrap: true, // Use shrinkWrap to prevent overflow
      physics:
          NeverScrollableScrollPhysics(), // Disable scrolling for the grid itself
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two items per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio:
            1.2, // Adjust child aspect ratio to make them more compact
      ),
      itemCount: nozzles.length,
      itemBuilder: (context, index) {
        return buildNozzleCard(
          context,
          pumpName,
          'media/petro.png', // Assuming an image for the nozzle
          nozzles[index]['nozzle_number'].toString(),
          nozzles,
        );
      },
    );
  }

  // Method to build each nozzle card
// Method to build each nozzle card
  Widget buildNozzleCard(BuildContext context, String pumpName,
      String imagePath, String nozzleNumber, List nozzles) {
    // Find the nozzle data for the specific nozzle number
    var nozzleData = nozzles.firstWhere(
      (nozzle) => nozzle['nozzle_number'].toString() == nozzleNumber,
      orElse: () => null,
    );

    // If nozzle data is not found, return an empty container or handle error
    if (nozzleData == null) {
      return const SizedBox.shrink();
    }

    String productName = nozzleData['product_name'] ??
        'Unknown'; // Default to 'Unknown' if product_name is not available
    String product_number = nozzleData['product_number'].toString() ??
        'Unknown'; // Default to 'Unknown' if product_name is not available

    return GestureDetector(
      onTap: () {
        // Navigate to the PresetValue page, passing both pumpnum and nozzleNum
        Get.toNamed("/PresetValue", arguments: {
          'pumpName': pumpName,
          'nozzleNum': nozzleNumber,
          'product_number': product_number,
        });
      },
      child: SizedBox(
        width: 170,
        child: Card(
          color: const Color.fromARGB(255, 24, 24, 24),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ("NOZZLE").tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xED166E36),
                          ),
                          child: Center(
                            child: Text(
                              nozzleNumber,
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ("Pump").tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.numbers_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                pumpName, // Display the pump number dynamically
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Display product name dynamically from nozzle data
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${productName}"
                              .tr, // Dynamically display the product name
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.oil_barrel_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
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
}
