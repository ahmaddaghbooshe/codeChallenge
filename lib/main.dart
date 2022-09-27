import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ScrollController _scrollController = ScrollController();
  getUrl() {
    if (search == "" && page == "") {
      return "https://g.tenor.com/v1/trending?&key=LIVDSRZULELA&limit=$limit&pos=$page";
    } else if (search != "" && page == "") {
      return "https://g.tenor.com/v1/search?q=$search&key=LIVDSRZULELA&limit=$limit";
    } else if (search == "" && page != "") {
      return "https://g.tenor.com/v1/trending?&key=LIVDSRZULELA&limit=$limit&pos=$page";
    } else {
      return "https://g.tenor.com/v1/search?q=$search&key=LIVDSRZULELA&limit=$limit&pos=$page";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void clearText() {
    fieldText.clear();
  }

  final fieldText = TextEditingController();
  bool isLoading = false;
  bool allLoaded = false;
  String search = "";
  String page = "";
  int limit = 8;
  List gifs = [];
  Future fetchData() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(getUrl());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["next"] == "") {
        setState(() {
          allLoaded = true;
        });
      }
      setState(() {
        gifs.addAll(data["results"]);
        page = data["next"];
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tenor GIF Search',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Container(
                child: const Center(
                  child: Text(
                    "Tenor GIF Search",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Code Challenge",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              search = "";
              page = "";
              gifs = [];
              clearText();
              fetchData();
            });
          },
          child: const Icon(Icons.refresh),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  controller: fieldText,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                  ),
                  onChanged: (value) {
                    setState(() {
                      search = value;
                      gifs = [];
                      page = "";
                      allLoaded = false;
                      fetchData();
                    });
                  }),
            ),
            Expanded(
              child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: gifs.length,
                  itemBuilder: (context, index) {
                    if (index == gifs.length - 1 && !allLoaded) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(
                                  url: gifs[index]["media"][0]["gif"]["url"],
                                  id: gifs[index]["id"],
                                  tags: gifs[index]["tags"],
                                  title: gifs[index]["title"],
                                  description: gifs[index]
                                      ["content_description"],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    gifs[index]["media"][0]["gif"]["url"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
