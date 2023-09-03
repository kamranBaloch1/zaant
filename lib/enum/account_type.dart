enum AccountTypeEnum {
  instructor,
  user,
  unknown,
}

extension AccountTypeToString on AccountTypeEnum {
  String get value {
    switch (this) {
      case AccountTypeEnum.instructor:
        return 'instructor'; // Matching the Firestore string value
      case AccountTypeEnum.user:
        return 'user'; // Matching the Firestore string value
      case AccountTypeEnum.unknown:
        return 'unknown'; // Matching the Firestore string value
    }
  }
}
