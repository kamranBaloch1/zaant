enum AccountTypeEnum {
  instructor,
  user,
  unknown,
}

extension AccountTypeToString on AccountTypeEnum {
  String get value {
    switch (this) {
      case AccountTypeEnum.instructor:
        return 'instructor';
      case AccountTypeEnum.user:
        return 'user';
      case AccountTypeEnum.unknown:
        return 'unknown';
    }
  }
}
