import 'package:database_practice/database_helper.dart';
import 'package:database_practice/item_detail_page.dart';
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

bool? deleteWithoutConfirmation = false;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> fetchAllItems() async {
      // Replace with your actual database query to fetch all items.
      // The returned value should be a List<Map<String, dynamic>>.
      return await getAll();
    }

    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

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

    void showChangePasswordDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  autocorrect: false,
                  decoration: InputDecoration(labelText: 'Old Password'),
                ),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  autocorrect: false,
                  decoration: InputDecoration(labelText: 'New Password'),
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

                  updatePassword(context, oldPasswordController.text,
                      newPasswordController.text);
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

    void confirmDeletionOfItems(BuildContext context, int id) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Are you Sure? you want to delete the item?",
                style: TextStyle(fontSize: 13),
              ),
              content: Container(
                  height: 100,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          StatefulBuilder(builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return Checkbox(
                              value: deleteWithoutConfirmation,
                              onChanged: (bool? value) {
                                deleteWithoutConfirmation = value;
                                print(deleteWithoutConfirmation);
                                setState(() {});
                              },
                            );
                          }),
                          Text("Always Delete without confirmation")
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            delete(id);
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text("Delete"))
                    ],
                  )),
            );
          });
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
                return InkWell(
                  onTap: (){

                      Navigator.push(context,MaterialPageRoute(builder: (context){
                        return ItemDetailsPage(data: item);
                      }));
                  },
                  child: ListTile(
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
                                if (deleteWithoutConfirmation!) {
                                  delete(item['id']);
                                } else {
                                  confirmDeletionOfItems(context, item['id']);
                                }
                                setState(() {});
                              },
                              onLongPress: () {
                                confirmDeletionOfItems(context, item['id']);
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
                  ),
                );
              },
            );
          }
        },
      ),
      endDrawer: Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return RegisterLoginPage();
                  }));
                  setState(() {});
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
              TextButton(
                onPressed: () {
                  showChangePasswordDialog(context);
                },
                child: Text(
                  "Change Password",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
            ],
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

Future<void> updatePassword(
    BuildContext context, String oldPassword, String newPassword) async {
  final prefs = await SharedPreferences.getInstance();
  String? email = await prefs.get('email').toString();
  String? password = await prefs.get('password').toString();

  if (newPassword.length < 6) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("NewPassword should contain atleast 6 characters!"),
            content: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          );
        });
    return;
  }

  if (password == oldPassword) {
    int id = await dataBaseHelper.findIDwithEmail(email);
    if (id != -1) {
      print("id is $id");
      Map<String, dynamic> updatedUser = {
        'id': id,
        'email': email,
        'password': newPassword
      };
      dataBaseHelper.updateUser(updatedUser);
      return;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("User Not Found!"),
              content: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok"),
              ),
            );
          });
    }
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Incorrect OldPassword!"),
            content: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          );
        });
  }
}
