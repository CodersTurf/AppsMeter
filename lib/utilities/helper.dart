import 'package:flutter/material.dart';
import 'package:AppsMeter/utilities/constants.dart';


List<Color> appUsageColors = [
  Colors.green,
  Colors.orange[600],
  Colors.redAccent
];
List getTodaysDateRange(int pastDaysNum) {
  DateTime pastDay = new DateTime.now().subtract(Duration(days: pastDaysNum));
  DateTime startDate =
      DateTime(pastDay.year, pastDay.month, pastDay.day,0,0);
  var endDate=pastDaysNum==0?DateTime.now(): startDate.add(Duration(hours: 24));
  return [startDate, endDate];
}

getDateRange(UsageDateRange range) {
  List<dynamic> dateRange = [];
  switch (range) {
    case UsageDateRange.today:
      dateRange = getTodaysDateRange(0);
      break;
    case UsageDateRange.oneWeek:
      dateRange = getDateRangeForPastDays(7);
      break;
    case UsageDateRange.twoWeek:
      dateRange = getDateRangeForPastDays(14);
      break;
    case UsageDateRange.oneMonth:
      dateRange = getDateRangeForPastDays(31);
      break;
    default:
      dateRange = null;
  }
  return dateRange;
}
List<String> getDailyHeaders()
{
  var headers=['Today','Yesterday'];
  for(var i=0;i<5;i++)
  {
    var day=weekDays[DateTime.now().subtract(Duration(days:i+2 )).weekday];
    headers.add(day);
  } 
  return headers;
}
List getDateRangeForPastDays(int numOfDays) {
  DateTime endDate = new DateTime.now();
  DateTime startDateF = endDate.subtract(new Duration(days: numOfDays-1));
  var startDate=DateTime(startDateF.year,startDateF.month,startDateF.day);
  return [startDate, endDate];
}
double convertSecondToMinutes(double seconds) {
  return roundtoTwoDigit(seconds / 60);
}

double convertSecondToHours(double seconds) {
  return roundtoTwoDigit(seconds / 3600);
}
roundtoTwoDigit(double number)
{
return double.parse(number.toStringAsFixed(2));
}
double getPercentOfHoursUsed(double usedSeconds,{numOfDays:1}) {  
  var val= (usedSeconds / (86400*numOfDays));
  return val;
}
capitalizeText(String text)
{
  var charFirst=text[0].toUpperCase();
  var remaininText=text.substring(1);
  return charFirst+remaininText;
}
String getSummaryTextFromSeconds(double seconds,{bool pieChartText=false}) {
  var usageDataFormatted = "";
  if (seconds > 3600) {
    seconds = convertSecondToHours(seconds);
    usageDataFormatted = seconds.toStringAsFixed(2) + (pieChartText?' h':' hrs');
  } else {
    seconds = convertSecondToMinutes(seconds);
    usageDataFormatted = seconds.toStringAsFixed(2) + (pieChartText?' m':' mns');
  }
  return usageDataFormatted;
}

Color getColorCodeForAllAppUsage(double seconds) {
  var hourUsed = seconds / 3600;
  if (hourUsed > 4) {
    return appUsageColors[2];
  }
  if (hourUsed > 2) {
    return appUsageColors[1];
  } else {
    return appUsageColors[0];
  }
}

Color getColorCodeForSingleAppUsage(double seconds) {
  var hourUsed = seconds / 3600;
  if (hourUsed > 2) {
    return appUsageColors[2];
  }
  if (hourUsed > 1) {
    return appUsageColors[1];
  } else {
    return appUsageColors[0];
  }
}

