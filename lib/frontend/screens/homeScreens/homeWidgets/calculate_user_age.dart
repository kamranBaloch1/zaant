class CalculateUserAge {
  static int? calculateAge(DateTime? dob) {
    if (dob == null) {
      return null; // or handle the case when dob is null
    }

    final currentDate = DateTime.now();
    final age = currentDate.year - dob.year - (currentDate.month > dob.month || (currentDate.month == dob.month && currentDate.day >= dob.day) ? 0 : 1);
    return age;
  }
}
