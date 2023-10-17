import 'package:database_practice/database_helper.dart';
import 'package:database_practice/register_login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: loadUserDetails(), // Implement this function.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final userExists = snapshot.data;

            if (userExists != null && userExists) {
              // User details found, navigate to HomePage.
              return MyHomePage();
            } else {
              // User details not found, navigate to LoginPage.
              return RegisterLoginPage();
            }
          } else {
            // While waiting for the future to complete, you can display a loading indicator.
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // delete(2);
    Map<String, dynamic> newItem = {
      'name': 'Jasshu',
      'description': 'MTS-1',
    };

    // insert(newItem);
    // printAll();
    // Map<String, dynamic>? item=getWithId(2);
    // print(item.toString());
    // item?['description']="MTS-1/SDE-1";

    Map<String, dynamic> updatedItem = {
      'id': 1,
      'name': 'Jasshu',
      'description': 'MTS-1/SDE-1',
    };

    // update(updatedItem);
    // printAll();

    Future<List<Map<String, dynamic>>> fetchAllItems() async {
      // Replace with your actual database query to fetch all items.
      // The returned value should be a List<Map<String, dynamic>>.
      return await getAll();
    }

    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    void showAddItemDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog.
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Save the item to the database and update the UI.
                  Map<String, dynamic> newItem = {
                    'name': nameController.text,
                    'description': descriptionController.text,
                  };

                  insert(newItem);
                  setState(() {
                    // Refresh the UI.
                  });

                  Navigator.of(context).pop(); // Close the dialog.
                },
                child: Text('Add'),
              ),
            ],
          );
        },
      );
    }

    void showUpdateItemDialog(BuildContext context, Map<String, dynamic> item) {
      nameController.text = item['name'];
      descriptionController.text = item['description'];
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog.
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Save the item to the database and update the UI.
                  Map<String, dynamic> newItem = {
                    'id': item['id'],
                    'name': nameController.text,
                    'description': descriptionController.text,
                  };

                  update(newItem);
                  setState(() {
                    // Refresh the UI.
                  });

                  Navigator.of(context).pop(); // Close the dialog.
                },
                child: Text('Update'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of Items from Database',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAllItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found.'));
          } else {
            // Use ListView.separated to display the list of items with separators.
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  leading: Text("${index + 1},${item['id']}"),
                  title: Text(item['name']),
                  subtitle: Text(item['description']),
                  trailing: Container(
                    width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              delete(item['id']);
                              setState(() {});
                            },
                            child: Icon(Icons.delete)),
                        InkWell(
                            onTap: () {
                              showUpdateItemDialog(context, item);
                            },
                            child: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      endDrawer: Container(
          child: ElevatedButton(
        onPressed: () {
          logout();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
            return RegisterLoginPage();
          }));
          setState(() {});
        },
        child: Text(
          "Logout",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddItemDialog(context);

          setState(() {});
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

DataBaseHelper dataBaseHelper = DataBaseHelper();

Future<void> insert(Map<String, dynamic> newItem) async {
  int id = await dataBaseHelper.insert(newItem);
  // print("printing id for " + newItem.toString());
  print("created " + id.toString());
}

Future<List<Map<String, dynamic>>> getAll() async {
  List<Map<String, dynamic>> allItems = (await dataBaseHelper.queryAll());
  return allItems;
}

Future<Map<String, dynamic>?> getWithId(int id) async {
  List<Map<String, dynamic>> data = (await dataBaseHelper.queryAll());
  for (int i = 0; i < data.length; i++) {
    if (data[i]['id'] == id) {
      return data[i];
    }
  }

  return null;
}

Future<void> delete(int id) async {
  print("deleted " + (await dataBaseHelper.delete(id)).toString());
}

void update(Map<String, dynamic> updatedItem) async {
  await dataBaseHelper.update(updatedItem);
}

Future<bool> loadUserDetails() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  final password = prefs.getString('password');

  if (email != null && password != null) {
    print("Found in shared prefs");
    return true;
  }
  return false;
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('email');
  prefs.remove('password');
}
