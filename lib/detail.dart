import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  List tags = [];
  String title;
  final String url;
  final String id;
  final String description;
  Detail(
      {Key? key,
      required this.url,
      required this.id,
      required this.tags,
      required this.title,
      required this.description})
      : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    getTags() {
      if (widget.tags.isEmpty) {
        return "No tags";
      } else {
        return widget.tags.toString();
      }
    }

    getTitle() {
      if (widget.title == "") {
        return "GIF Detail";
      } else {
        return widget.title;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Text(
          getTitle(),
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                widget.url,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text("ID: ${widget.id}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13)),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Description: ${widget.description}",
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Tags: ${getTags()}",
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
