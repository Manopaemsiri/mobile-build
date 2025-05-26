extension DateTimeExtension on DateTime? {
  
  bool? isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isAfter(dateTime);
    }
    return null;
  }

  bool? isBeforeOrEqualTo(DateTime? dateTime) {
    if(dateTime != null){
      final date = this;
      if (date != null) {
        final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
        return isAtSameMomentAs | date.isBefore(dateTime);
      }
    }
    return null;
  }

  bool? isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    if (date != null) {
      final isAfter = date.isAfterOrEqualTo(fromDateTime) ?? false;
      final isBefore = date.isBeforeOrEqualTo(toDateTime) ?? false;
      return isAfter && isBefore;
    }
    return null;
  }

  bool isSameDay(DateTime other) {
    return this?.year == other.year &&
      this?.month == other.month &&
      this?.day == other.day;
  }

  bool isSameHour(DateTime other) {
    return this?.year == other.year &&
      this?.month == other.month &&
      this?.day == other.day &&
      this?.hour == other.hour;
  }

  bool isSameMinute(DateTime other) {
    return this?.year == other.year &&
      this?.month == other.month &&
      this?.day == other.day &&
      this?.hour == other.hour &&
      this?.minute == other.minute;
  }
}