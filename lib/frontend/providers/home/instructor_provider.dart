import 'package:flutter/foundation.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/server/home/instructor_methods.dart';

class InstructorProviders extends ChangeNotifier {
  final InstructorMethods _instructorMethods = InstructorMethods();

  Future<void> addInstructor(
      {required String phoneNumber,
      required String qualification,
      required String location,
      required List<String> subjects,
      required int feesPerHour,
      required List<String> availableTimings}) async {
    try {
    await  _instructorMethods.addInstructor(
          phoneNumber: phoneNumber,
          qualification: qualification,
          location: location,
          subjects: subjects,
          feesPerHour: feesPerHour,
          availableTimings: availableTimings);

      notifyListeners();
    } catch (e) {

      showCustomToast("error accoured");
    }
  }
}
