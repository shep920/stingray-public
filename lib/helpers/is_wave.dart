class IsWave {
  static bool onTime(DateTime time) {
    //make it valid if time is between 10:00pm and 10:02pm
    DateTime now = DateTime.now();
    DateTime todayTenPM = DateTime(now.year, now.month, now.day, 22, 0);
    DateTime todayTenTwoPM = DateTime(now.year, now.month, now.day, 22, 2);

    //valid if time is between 10:00pm and 10:02pm
    if (time.isAfter(todayTenPM) && time.isBefore(todayTenTwoPM)) {
      return true;
    } else {
      return false;
    }
  }

  static bool validSeaReal(DateTime lastPostTime) {
    DateTime now = DateTime.now();
    DateTime todayTenPM = DateTime(now.year, now.month, now.day, 22, 0);
    DateTime yesterdayTenPM = todayTenPM.subtract(Duration(days: 1));

    if (lastPostTime.isBefore(yesterdayTenPM)) {
      // User has not posted yet today
      return true;
    } else if (lastPostTime.isBefore(todayTenPM)) {
      // User has already posted today
      return false;
    } else {
      // User is trying to post after 10 PM
      return true;
    }
  }
}
