import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/home/profile_providers.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';
import 'package:zaanth/global/constant_values.dart';
import 'package:zaanth/sharedprefences/userPref.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/custom_cities_dropdown.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameC;

  File? _selectedImage;

  String? profilePicUrl;
  String? name;

  String? selectedCity;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadingTheState();
  }

  Future<void> _loadingTheState() async {
    await Future.delayed(const Duration(seconds: 1));
    _fetchUserInfoFromSharedPref();
  }

  @override
  void dispose() {
    _nameC.dispose();

    super.dispose();
  }

  Future<void> _fetchUserInfoFromSharedPref() async {
    // Fetch user info from SharedPreferences
    name = UserPreferences.getName();
    selectedCity = UserPreferences.getCity();
    profilePicUrl = UserPreferences.getProfileUrl();

    // Initialize the controllers after fetching data from SharedPreferences
    _nameC = TextEditingController(text: name);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectProfilePicture() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      showCustomToast("Error selecting profile picture: $e");
    }
  }

  void _updateUserInfo() async {
    String name = _nameC.text.trim();
   // Capitalize each word in the name
name = name.split(' ').map((word) => word.substring(0, 1).toUpperCase() + word.substring(1)).join(' ');


    if (name.isNotEmpty) {
      if (selectedCity == null) {
        showCustomToast("please select your city");
        return;
      }
      setState(() {
        _isLoading = true;
      });

      final accountProvider =
          Provider.of<ProfileProviders>(context, listen: false);

      await accountProvider.updateUserInformationProvider(
        name: name,
        imageUrl: _selectedImage,
        selectedCity: selectedCity!,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      showCustomToast("Please write your name");
    }
  }

  Widget _buildProfileAvatar() {
    return Center(
      child: GestureDetector(
        onTap: _selectProfilePicture,
        child: CircleAvatar(
          radius: 80.r,
          backgroundImage: _selectedImage != null
              ? Image.file(_selectedImage!).image
              : profilePicUrl != null
                  ? NetworkImage(profilePicUrl!)
                  : NetworkImage(defaultNetworkProfileImage),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
            title: "Edit Profile",
            backgroundColor: appBarColor,
          ),
          body: _isLoading
              ? Container()
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileAvatar(),
                      SizedBox(height: 40.h),
                      HomeCustomTextField(
                        controller: _nameC,
                        labelText: 'Name',
                        icon: Icons.person,
                        keyBoardType: TextInputType.name,
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: CustomCitiesDropdown(
                          selectedCity: selectedCity,
                          labelText: "Change your city",
                          onChanged: (value) {
                            setState(() {
                              selectedCity = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Center(
                        child: ElevatedButton(
                          onPressed: _updateUserInfo,
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        // Show loading overlay if Loading is true
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
