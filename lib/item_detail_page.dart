import 'package:flutter/material.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({super.key, required this.data});

  final Map<String, dynamic>? data;

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  Future<bool> onWillPop() async {
    // Perform your custom back button logic here
    // Return true to allow back navigation, or false to prevent it
    Navigator.pop(context, "Data from onWillPop");
    print("back pressed ");
    return true; // You can return false to prevent back navigation.
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { return onWillPop(); },
      child: Scaffold(
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
      ),
    );
  }
}
