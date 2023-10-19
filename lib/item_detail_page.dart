import 'package:flutter/material.dart';

class ItemDetailsPage extends StatefulWidget {
   const ItemDetailsPage({super.key, required this.data});
   final Map<String, dynamic>? data;

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item details"),
      ),
      body: Center(
        child: Container(
          height: 200,
          child: Column(
            children: [
              Text("${widget.data?['name']}"),
              Text("${widget.data?['description']}"),
            ],
          ),
        ),
      ),
    );
  }
}
