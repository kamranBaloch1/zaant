import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/home/profile_methods.dart';

class UpdateChargesPerHour extends StatefulWidget {
  final int feesPerHour;
  const UpdateChargesPerHour({
    Key? key,
    required this.feesPerHour,
  }) : super(key: key);

  @override
  State<UpdateChargesPerHour> createState() => _UpdateChargesPerHourState();
}

class _UpdateChargesPerHourState extends State<UpdateChargesPerHour> {
  late final TextEditingController _feesPerHour;

  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _feesPerHour.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    _feesPerHour = TextEditingController(text: widget.feesPerHour.toString());

    super.initState();
  }

  Future<void> _updateCharges() async {
    setState(() {
      _isLoading = true;
    });

    String charges = _feesPerHour.text.trim();
    if (charges.isNotEmpty) {
      await ProfileMethods()
          .updateInstrcutorFeesCharges(feesPerHour: int.parse(charges));

      setState(() {
        _isLoading = false;
      });
    } else {
      showCustomToast("please fill out the field");
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
          appBar: CustomAppBar(
              backgroundColor: appBarColor, title: "Update Fees Per Hour"),
          body: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              homeCustomTextField(
                controller: _feesPerHour,
                labelText: "update per hour",
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
                text: "update",
                bgColor: Colors.blue,
              )
            ],
          ),
        ),
        // Show loading overlay if Loading is true
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
