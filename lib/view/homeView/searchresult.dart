import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  final String value;
  const SearchResult({Key? key, required this.value}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Suggestion'),
      ),
      body: Center(
        child: Text(
          'You selected: ${widget.value}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
