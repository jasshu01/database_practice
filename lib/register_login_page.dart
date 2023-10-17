import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class RegisterLoginPage extends StatefulWidget {
  @override
  State<RegisterLoginPage> createState() => _RegisterLoginPageState();
}

class _RegisterLoginPageState extends State<RegisterLoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    bool validateEmailString(String email) {
      return true;
    }

    bool validatePasswordString(String password) {
      return true;
    }

    void showRegisterUserDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Register User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    icon: Icon(Icons.email),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    icon: Icon(Icons.key),
                  ),
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
                    'email': usernameController.text,
                    'password': passwordController.text,
                  };

                  addUser(newItem);
                  setState(() {
                    // Refresh the UI.
                  });

                  Navigator.of(context).pop(); // Close the dialog.
                },
                child: Text('Register'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  icon: Icon(Icons.email),
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  icon: Icon(Icons.key),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> user = {
                      'email': usernameController.text,
                      'password': passwordController.text,
                    };

                    if (await findUser(user)) {
                      print("found user");
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MyHomePage();
                      }));
                    } else {
                      print(" user not found");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Incorrect Credentials"),
                              content: TextButton(
                                child: Text("ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          });
                    }

                    setState(() {});
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20),
                  )),
              TextButton(
                  onPressed: () {
                    showRegisterUserDialog(context);
                    setState(() {});
                  },
                  child: Text("New user? Register")),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> addUser(Map<String, dynamic> newItem) async {
  await dataBaseHelper.addUser(newItem);
}

Future<bool> findUser(Map<String, dynamic> newItem) async {
  return await dataBaseHelper.findUser(newItem);
}
