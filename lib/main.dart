import 'package:flutter/material.dart';
import 'dart:async';
import 'package:library_project/database_manager.dart' as database_manager;
import 'package:library_project/information_retrieval.dart' as information_retrieval;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

//main function
void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget mainWidget = Item1(); // Add this here
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Library helper'),
          backgroundColor: Colors.deepPurple,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              //Homepage
              ListTile(
                title: Text('Homepage'),
                onTap: () {
                  setState(() {
                    mainWidget = Item1();
                  });
                  Navigator.pop(context);
                },
              ),
              //Available
              ListTile(
                title: Text('Availability in the library'),
                onTap: () {
                  setState(() {
                    mainWidget = Item2();
                  });
                  Navigator.pop(context);
                },
              ),
              //find items in the library
              ListTile(
                title: Text('Need help finding a section?'),
                onTap: () {
                  setState(() {
                    mainWidget = Item3();
                  });
                  Navigator.pop(context);
                },
              ),
              //opening times in the library
              ListTile(
                title: Text('Opening times'),
                onTap: () {
                  setState(() {
                    mainWidget = Item4();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: mainWidget,
      ),
    );
  }
}

//homepage
class Item1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0), // Add padding to all sides
              child: Text("Homepage", style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding only
              child: Text(
                "Welcome to the library helper app!\n\nUse the menu to select your options.",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () => launch("https://library.port.ac.uk/"),
                child: Text("Visit Library Website", style: TextStyle(fontSize: 18, color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//availability
class Item2 extends StatefulWidget {
  @override
  _Item2State createState() => _Item2State();
}

class _Item2State extends State<Item2> {
  int availableComputers = 0;
  FlutterWebviewPlugin _webviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    fetchAvailableComputers();
  }

  @override
  void dispose() {
    _webviewPlugin.dispose();
    super.dispose();
  }

  Future<void> fetchAvailableComputers() async {
    information_retrieval.InformationRetrieval infoRetrieval = information_retrieval.InformationRetrieval();
    int computers = await infoRetrieval.fetchAvailableComputers();
    setState(() {
      availableComputers = computers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0), // Add padding to all sides
              child: Text("Availability in the library", style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "There are currently $availableComputers computers in the library, out of a possible 369",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () => launch("https://ssd.port.ac.uk/myport/it/openaccess-availability/"),
                child: Text("Check available computers on the site", style: TextStyle(fontSize: 18, color: Colors.blue)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () => launch("http://libacs-app-01.uni.ds.port.ac.uk/isisroombooking.dll/EXEC/0/0hmh57s0303buj11rhncg1aj6mcq"),
                child: Text("Book Rooms in the Library", style: TextStyle(fontSize: 18, color: Colors.blue)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 5,
              child: WebviewScaffold(
                url: 'https://ssd.port.ac.uk/myport/it/openaccess-availability/',
                withJavascript: true,
                withLocalStorage: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//finding
class Item3 extends StatefulWidget {
  @override
  _Item3State createState() => _Item3State();
}

class _Item3State extends State<Item3> {
  String searchQuery = "";
  List<database_manager.LibraryCategory> searchResults = [];

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
    performSearch();
  }

  void performSearch() async {
    List<database_manager.LibraryCategory> results = await database_manager.searchLibraryCategory(searchQuery);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0), // Add padding to all sides
              child: Text("Need help finding a section?", style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Here are the general categories, use the search bar for a more specific section.\n"
                    "Computer science, information and general works: 000-099\n"
                    "Philosophy and psychology: 100-199\n"
                    "Religion: 200-299\n"
                    "Social sciences: 300-399\n"
                    "Languages and linguistics: 400-499\n"
                    "Natural sciences and mathematics: 500-599\n"
                    "Technology: 600-699\n"
                    "Arts and recreation: 700-799\n"
                    "Literature: 800-899\n"
                    "History and geography: 900-999\n",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () => launch("https://library.port.ac.uk/classmark/index.php?xid=L1126&state=1"),
                child: Text("More information about library sections", style: TextStyle(fontSize: 18, color: Colors.blue)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: updateSearchQuery,
                decoration: InputDecoration(
                  labelText: "Search for a section",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            //view search results
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  database_manager.LibraryCategory category = searchResults[index];
                  return ListTile(
                    title: Text("Section Name: ${category.sectionName}"),
                    subtitle: Text("Section Number ${category.sectionNumber}, Floor: ${category.floor}"),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Library Floor Maps", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  "https://library.port.ac.uk/more/media/1/m167_365b3_thumb.png",
                  height: 100,
                ),
                Image.network(
                  "https://library.port.ac.uk/more/media/1/m169_2d9b8_thumb.png",
                  height: 100,
                ),
                Image.network(
                  "https://library.port.ac.uk/more/media/1/m171_46a32_thumb.png",
                  height: 100,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//opening times
class Item4 extends StatelessWidget {
  Future<bool> fetchDataFromDatabase(BuildContext context) async {
    Completer<bool> completer = Completer<bool>();
    database_manager.returnStatus().then((value) {
      completer.complete(value);
    });
    return completer.future;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<bool>(
          future: fetchDataFromDatabase(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching data'));
            } else {
              bool isLibraryOpen = snapshot.data ?? false;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0), // Add padding to all sides
                    child: Text("Opening times", style: TextStyle(fontSize: 30)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Library is currently ${isLibraryOpen ? 'open' : 'closed'}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () => launch("https://library.port.ac.uk/open/"),
                      child: Text("More information about library opening times", style: TextStyle(fontSize: 18, color: Colors.blue)),
                    ),
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }
}