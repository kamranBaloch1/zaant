import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/home/profile_providers.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/global/constant_values.dart';
import 'package:zant/sharedprefences/userPref.dart';

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

  bool _isShimmerLoading = true;
  bool _isLoading = false;

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
    profilePicUrl = UserPreferences.getProfileUrl();

    // Initialize the controllers after fetching data from SharedPreferences
    _nameC = TextEditingController(text: name);

    setState(() {
      _isShimmerLoading = false;
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
    setState(() {
      _isLoading = true;
    });

    String name = _nameC.text.trim();

    if (name.isNotEmpty) {
      final accountProvider =
          Provider.of<ProfileProviders>(context, listen: false);

      await accountProvider.updateUserInformationProvider(name, _selectedImage);

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
      showCustomToast("Please fill out all the fields");
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
          appBar: ReusableAppBar(
            title: _isLoading ? "Updating..." : "Edit Profile",
            backgroundColor: appBarColor,
          ),
          body: _isShimmerLoading
              ? Container()
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileAvatar(),
                      SizedBox(height: 40.h),
                      homeCustomTextField(
                        controller: _nameC,
                        labelText: 'Name',
                        icon: Icons.person,
                        keyBoardType: TextInputType.name,
                      ),
                      SizedBox(height: 40.h),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateUserInfo,
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        // Show loading overlay if Loading is true
        if (_isLoading) const CustomLoadingOverlay(),
        if (_isShimmerLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
