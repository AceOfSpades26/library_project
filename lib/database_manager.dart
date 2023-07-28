import 'dart:io';

//check whether open
//variables needed
class CheckOpeningHours {
  final int dayOfWeek;
  final String openingTime;
  final String closingTime;

  CheckOpeningHours({required this.dayOfWeek, required this.openingTime, required this.closingTime});
  factory CheckOpeningHours.fromLine(String line) {
    List<String> fields = line.split(",");
    return CheckOpeningHours(
      dayOfWeek: int.parse(fields[0]),
      openingTime: fields[1],
      closingTime: fields[2],
    );
  }
}

//read opening time file
Future<List<CheckOpeningHours>> fetchOpeningHours() async {
  final File file = File('opening_times.txt');
  List<String> lines = await file.readAsLines();
  return lines.map((line) => CheckOpeningHours.fromLine(line)).toList();
}

//format times to see if open
bool isLibraryOpen(List<CheckOpeningHours> openingHoursData, DateTime currentTime) {
  int currentDayOfWeek = currentTime.weekday - 1;
  CheckOpeningHours nowOpeningHours = openingHoursData.firstWhere((n) => n.dayOfWeek == currentDayOfWeek);
  DateTime openingTime = DateTime(currentTime.year, currentTime.month, currentTime.day,
      int.parse(nowOpeningHours.openingTime.split(":")[0]), int.parse(nowOpeningHours.openingTime.split(":")[1]));
  DateTime closingTime = DateTime(currentTime.year, currentTime.month, currentTime.day,
      int.parse(nowOpeningHours.closingTime.split(":")[0]), int.parse(nowOpeningHours.closingTime.split(":")[1]));
  return currentTime.isAfter(openingTime) && currentTime.isBefore(closingTime);
}

Future<bool> returnStatus() async {
  try {
    List<CheckOpeningHours> openingHoursData = await fetchOpeningHours();
    DateTime currentTime = DateTime.now();
    bool isOpen = false;
    if (currentTime.month == 8 && currentTime.day == 28) {
      isOpen = false;
    } else if ((currentTime.month >= 6 && currentTime.day >= 9) && (currentTime.month <= 9 && currentTime.day <=17)) {
      isOpen = isLibraryOpen(openingHoursData, currentTime);
    } else {
      isOpen = true;
    }
    return isOpen;
  } catch (e) {
    print('Error fetching opening hours : $e');
    return false;
  }
}

//find library section
//variables needed
class LibraryCategory {
  final String sectionName;
  final String sectionNumber;
  final String floor;

  //format sections
  LibraryCategory({required this.sectionName, required this.sectionNumber, required this.floor});
  factory LibraryCategory.fromLine(String line) {
    List<String> fields = line.split(";");
    return LibraryCategory(
      sectionName: fields[0],
      sectionNumber: fields[2],
      floor: fields[1]
    );
  }
}

//search for categories from file
Future<List<LibraryCategory>> searchLibraryCategory(String query) async {
  final File file = File('section_locater.txt');
  List<String> lines = await file.readAsLines();
  List<LibraryCategory> categories = lines
      .map((line) => LibraryCategory.fromLine(line))
      .where((category) => category.sectionName.contains(query.toLowerCase()))
      .toList();
  return categories;
}