import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/home/instructor_provider.dart';
import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';
import 'package:zaanth/sharedprefences/userPref.dart';

class UpdateAdressScreen extends StatefulWidget {
  final String? address;

  const UpdateAdressScreen({super.key, required this.address});

  @override
  State<UpdateAdressScreen> createState() => _UpdateAdressScreenState();
}

class _UpdateAdressScreenState extends State<UpdateAdressScreen> {
  late TextEditingController _address;

  bool _isLoading = false;
  String? userCity;

  @override
  void initState() {
    _address = TextEditingController(text: widget.address);
    userCity = UserPreferences.getCity();
    super.initState();
  }

  // Function to update the address
  void _updateAddress() async {
    setState(() {
      _isLoading = true;
    });

    String address = _address.text.trim();
    if (address.isNotEmpty) {
      // Call the backend method to update the fees per hour
      final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);
      await instructorProvider.updateInstructorAddressProvider(
          address: address);

      setState(() {
        _isLoading = false;
      });
    } else {
      showCustomToast("Please fill out the field");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
              backgroundColor: appBarColor, title: "Change address"),
          body: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Note : Please add your full adresss ",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Example : Areaname/BuildingName/flat No",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45),
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                "Your City ($userCity)",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(
                height: 50.h,
              ),
              HomeCustomTextField(
                  controller: _address,
                  labelText: "New address",
                  icon: Icons.home,
                  keyBoardType: TextInputType.text),
              SizedBox(
                height: 40.h,
              ),
              CustomButton(
                onTap: _updateAddress,
                width: 200,
                height: 40,
                text: "Update",
                bgColor: Colors.blue,
              )
            ],
          ),
        ),
        // Show loading overlay if _isLoading is true
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
