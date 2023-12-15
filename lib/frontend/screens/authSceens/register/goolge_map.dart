

import 'package:flutter/material.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/global/colors.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class OpenStreetPickLocation extends StatefulWidget {
  const OpenStreetPickLocation({super.key});

  @override
  State<OpenStreetPickLocation> createState() => _OpenStreetPickLocationState();
}

class _OpenStreetPickLocationState extends State<OpenStreetPickLocation> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CustomAppBar(backgroundColor: appBarColor, title: "Pick your location"),
      body: Column(
        children: [
           
           Expanded(
             child: Container(
              color: Colors.black,
               child: OpenStreetMapSearchAndPick(
                hintText: "Kamran",
                
                     center: LatLong(23, 89),
                     locationPinTextStyle: TextStyle(color: Colors.black),
                     buttonColor: Colors.black,
                     
                     buttonText: 'Set Current Location',
                     onPicked: (pickedData) {
                       print(pickedData.latLong.latitude);
                       print(pickedData.latLong.longitude);
                       print(pickedData.address);
                     },
                     
                     ),
             ),
           )



        ],
      ),
    );
  }
}