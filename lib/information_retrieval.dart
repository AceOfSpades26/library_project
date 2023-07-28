import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

class InformationRetrieval {
  Future<int> fetchAvailableComputers() async {
    final String url = 'https://ssd.port.ac.uk/myport/it/openaccess-availability/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final Element? computerElement = document.querySelector('.available-computers');
        int availableComputers = int.parse(computerElement?.text ?? '0');
        return availableComputers;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return 0;
    }
  }
}