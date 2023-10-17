import 'package:database_practice/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';


DataBaseHelper dataBaseHelper=DataBaseHelper();
class RegisterLoginPage extends StatefulWidget {
  @override
  State<RegisterLoginPage> createState() => _RegisterLoginPageState();
}

class _RegisterLoginPageState extends State<RegisterLoginPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    String? validateEmail(String? email) {
      if (email!.isEmpty) {
        return 'Please enter your email.';
      }

      // You can use a regular expression to validate the email format.
      final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
      if (!emailRegex.hasMatch(email!)) {
        return 'Please enter a valid email address.';
      }

      return null;
    }

    String? validatePassword(String? password) {
      if (password!.isEmpty) {
        return 'Please enter your password.';
      }

      if (password.length < 6) {
        return 'Password must be at least 6 characters.';
      }

      return null;
    }

    void submitForm() {
      if (_formKey.currentState!.validate()) {
        Map<String, dynamic> newItem = {
          'email': usernameController.text,
          'password': passwordController.text,
        };

        addUser(newItem, context);
        setState(() {
          // Refresh the UI.
        });

        Navigator.of(context).pop(); // Close the dialog.
        // Reset the form after submission if needed.
        _formKey.currentState!.reset();

        return;
      }
    }



    void showRegisterUserDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Register User'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: usernameController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      icon: Icon(Icons.email),
                    ),
                    validator: validateEmail,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    autocorrect: false,
                    validator: validatePassword,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      icon: Icon(Icons.key),
                    ),
                  ),
                ],
              ),
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
                  submitForm();
                  // Save the item to the database and update the UI.
                  // Map<String, dynamic> newItem = {
                  //   'email': usernameController.text,
                  //   'password': passwordController.text,
                  // };

                  // addUser(newItem);
                  // setState(() {
                  //   // Refresh the UI.
                  // });
                  //
                  // Navigator.of(context).pop(); // Close the dialog.
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

                      saveUserDetails(usernameController.text,passwordController.text);

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

Future<void> addUser(Map<String, dynamic> newItem, BuildContext context) async {
  if (await dataBaseHelper.findwithEmail(newItem['email'])) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email Already exists"),
            content: TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        });
    return;
  }
  await dataBaseHelper.addUser(newItem);
}

Future<bool> findUser(Map<String, dynamic> newItem) async {
  return await dataBaseHelper.findUser(newItem);
}

Future<void> saveUserDetails(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();

  // Save user details securely.
  await prefs.setString('email', email);
  await prefs.setString('password', password);
  print("saving in shared prefs");
}
