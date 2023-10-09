import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:zant/frontend/models/home/instructor_model.dart';
import 'package:zant/frontend/providers/home/instructor_provider.dart';
import 'package:zant/frontend/screens/homeScreens/drawer/drawer.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/details/instructor_details_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}): super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: appBarColor, title: "Search Screen"),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (query) {
                    // Update the search results dynamically as the user types
                    // _updateSearchResults(query);
                  },
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ), // Add some spacing below the search field
                ElevatedButton(
                  onPressed: () {
                    // Check if the search field is empty
                    if (_searchController.text.isEmpty) {
                      showCustomToast("Please enter a search query");
                    } else {
                      // Show the search results when the "Search" button is pressed
                      setState(() {
                        _showResults = true;
                      });
                    }
                  },
                  child: const Text("Search"),
                ),
              ],
            ),
          ),
          // Show search results only when _showResults is true
          if (_showResults)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Provider.of<InstructorProviders>(context)
                    .getInstructorsStreamProvider(
                        query: _searchController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Error: ',
                        style: TextStyle(color: Colors.black));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No results found.',
                            style: TextStyle(color: Colors.black)));
                  } else {
                    // Extract and display instructor data
                    final instructorDocs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: instructorDocs.length,
                      itemBuilder: (context, index) {
                        final instructorData = instructorDocs[index].data();
                        return _buildInstructorTile(
                            instructorData as Map<String, dynamic>);
                      },
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

 Widget _buildInstructorTile(Map<String, dynamic> instructorData) {
  // Extract instructor information
  final String instructorName = instructorData['name'];
  final String instructorLocation = instructorData['address'];
  final String instructorProfilePicUrl = instructorData['profilePicUrl'];
  final String city = instructorData['city'];
  final double instructorRating =
      instructorData['ratings'] ?? 0.0; // Get the instructor's rating

  return GestureDetector(
    onTap: () {
      Get.to(() => InstructorDetailScreen(
          instructorModel: InstructorModel.fromMap(instructorData)));
    },
    child: ListTile(
      title: Text(
        instructorName,
        style: const TextStyle(color: Colors.black), // Text color in black
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                city,
                style: const TextStyle(
                    color: Colors.black54), // Text color in black
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                instructorLocation,
                style: const TextStyle(
                    color: Colors.black45), // Text color in black
              ),
            ],
          ),
          Row(
            children: [
            const  Text(
                'Rating: ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color: index < instructorRating ? Colors.amber : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundImage:
            NetworkImage(instructorProfilePicUrl), // Use the instructor's profile picture
      ),
      // Add more widgets to display instructor details as needed
    ),
  );
}


}
