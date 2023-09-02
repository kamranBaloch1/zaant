// import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';

// class AutoCompleteSearch extends StatefulWidget {
//   @override
//   _AutoCompleteSearchState createState() => _AutoCompleteSearchState();
// }

// class _AutoCompleteSearchState extends State<AutoCompleteSearch> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Address> _searchResults = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AutoComplete Search'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               onChanged: _onSearchTextChanged,
//               decoration: InputDecoration(
//                 hintText: 'Search for a place',
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _searchResults.length,
//               itemBuilder: (context, index) {
//                 final address = _searchResults[index];
//                 return ListTile(
//                   title: Text(address.featureName),
//                   subtitle: Text(address.addressLine),
//                   onTap: () {
//                     // Handle the selected location
//                     // You can use the selected location for your purposes.
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onSearchTextChanged(String query) async {
//     final addresses = await Geocoder.local.findAddressesFromQuery(query);
//     setState(() {
//       _searchResults = addresses;
//     });
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: AutoCompleteSearch(),
//   ));
// }
