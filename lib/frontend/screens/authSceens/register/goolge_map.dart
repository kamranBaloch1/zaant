// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';

// class SearchPlaces extends StatefulWidget {
//   const SearchPlaces({Key? key}) : super(key: key);

//   @override
//   State<SearchPlaces> createState() => _SearchPlacesState();
// }

// class _SearchPlacesState extends State<SearchPlaces> {
//   final TextEditingController _searchController = TextEditingController();
//   List<String> searchResults = [];
//   String selectedProvince = '';
//   String selectedCity = '';

//   // Define the provinces and cities
//   List<String> provinces = ['Punjab', 'Sindh', 'Khyber Pakhtunkhwa', 'Balochistan'];
//   Map<String, List<String>> cities = {
//     'Punjab': ['Lahore', 'Rawalpindi', 'Faisalabad'],
//     'Sindh': ['Karachi', 'Hyderabad', 'Sukkur'],
//     'Khyber Pakhtunkhwa': ['Peshawar', 'Abbottabad', 'Swat'],
//     'Balochistan': ['Quetta', 'Gwadar', 'Chaman'],
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Places'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Province Dropdown
//             DropdownButton<String>(
//               value: selectedProvince,
//               hint: Text('Select Province'),
//               items: provinces.map((province) {
//                 return DropdownMenuItem<String>(
//                   value: province,
//                   child: Text(province),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedProvince = value!;
//                   selectedCity = '';
//                   _searchController.clear();
//                   searchResults.clear();
//                 });
//               },
//             ),
//             SizedBox(height: 16),

//             // City Dropdown
//             DropdownButton<String>(
//               value: selectedCity,
//               hint: Text('Select City'),
//               items: cities[selectedProvince]?.map((city) {
//                 return DropdownMenuItem<String>(
//                   value: city,
//                   child: Text(city),
//                 );
//               }).toList() ?? [],
//               onChanged: (value) {
//                 setState(() {
//                   selectedCity = value!;
//                   _searchController.clear();
//                   searchResults.clear();
//                 });
//               },
//             ),
//             SizedBox(height: 16),

//             // Search TextField
//             TextField(
//               controller: _searchController,
//               onChanged: (value) {
//                 searchLocation(value);
//               },
//               enabled: selectedCity.isNotEmpty,
//               decoration: InputDecoration(
//                 hintText: 'Enter an area name',
//               ),
//             ),
//             SizedBox(height: 16),

//             // Search Results
//             Text(
//               'Search Results:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: searchResults.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(
//                       searchResults[index],
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> searchLocation(String query) async {
//     try {
//       if (selectedCity.isNotEmpty) {
//         List<Location> locations = await locationFromAddress('$query, $selectedCity, $selectedProvince, Pakistan');
//         setState(() {
//           searchResults = locations.map((location) => location.formattedAddress ?? '').toList();
//         });
//       } else {
//         setState(() {
//           searchResults = ['Please select a city'];
//         });
//       }
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         searchResults = ['Error fetching location'];
//       });
//     }
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: SearchPlaces(),
//   ));
// }
