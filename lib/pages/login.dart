import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // text controllers
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController password = TextEditingController();

  bool error = false, sending = false, success = false;
  String msg = '';

  Future sendData() async {
    // server url
    String url = 'http://192.168.8.101';

    Response res =
        await post(Uri.parse(url + '/fluttermysql/write.php'), body: {
      "firstname": firstname.text,
      "lastname": lastname.text,
      "phonenumber": phonenumber.text,
      "password": password.text
    });

    if (res.statusCode == 200) {
      print(res.body);
      Map data = jsonDecode(res.body);
      if (data['error']) {
        setState(() {
          sending = false;
          error = true;
          msg = data['message'];
        });
      } else {
        // send is successful
        // make fields empty
        firstname.text = '';
        lastname.text = '';
        phonenumber.text = '';
        password.text = '';

        setState(() {
          sending = false;
          success = true;
        });

        // Navigator.pushReplacement(context, (context) => build(context))
      }
    } else {
      // there is an error
      setState(() {
        error = true;
        msg = 'Error sending data';
        sending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter MySQL"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: Text(
                  error ? msg : 'Enter your info',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(success ? 'Write success' : "Send data",
                    style: TextStyle(fontSize: 20)),
              ),
              Container(
                child: TextField(
                  controller: firstname,
                  decoration: InputDecoration(
                      labelText: 'First Name', hintText: 'Enter first name'),
                ),
              ),
              Container(
                child: TextField(
                  controller: lastname,
                  decoration: InputDecoration(
                      labelText: 'Last Name', hintText: 'Enter last name'),
                ),
              ),
              Container(
                child: TextField(
                  controller: phonenumber,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter phone number'),
                ),
              ),
              Container(
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                      labelText: 'Password', hintText: 'Enter password'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        sending = true;
                      });
                      sendData();
                    },
                    child: Text(
                      sending ? 'Sending...' : 'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
