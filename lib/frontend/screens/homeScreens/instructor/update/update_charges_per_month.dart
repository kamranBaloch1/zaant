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

class UpdateChargesPerMonth extends StatefulWidget {
  final int feesPerMonth;

  const UpdateChargesPerMonth({
    Key? key,
    required this.feesPerMonth,
  }) : super(key: key);

  @override
  State<UpdateChargesPerMonth> createState() => _UpdateChargesPerMonthState();
}

class _UpdateChargesPerMonthState extends State<UpdateChargesPerMonth> {
  late final TextEditingController _feesPerMonth;
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _feesPerMonth.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the initial feesPerHour value.
    _feesPerMonth = TextEditingController(text: widget.feesPerMonth.toString());
  }

  // Function to update the charges per hour
  void _updateCharges() async {
    setState(() {
      _isLoading = true;
    });

    String charges = _feesPerMonth.text.trim();
    if (charges.isNotEmpty) {
      // Call the backend method to update the fees per hour
      final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);
      await instructorProvider.updateInstructorFeesChargesProvider(
        feesPerMonth: int.parse(charges),
      );

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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const  CustomAppBar(
            backgroundColor: appBarColor,
            title:  "Change fees per month",
          ),
          body: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              HomeCustomTextField(
                controller: _feesPerMonth,
                labelText: "Update per month",
                icon: Icons.money,
                keyBoardType: TextInputType.number,
              ),
              SizedBox(
                height: 40.h,
              ),
              CustomButton(
                onTap: _updateCharges,
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
