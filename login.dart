import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/Users.dart';
import '../models/config.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  Users user = Users();
  List<Users> users = [];
  bool _isLoading = false;

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadUserData();

    _usernameFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
    final String response = await rootBundle.loadString('assets/data/product.json');
    final data = await json.decode(response);
    setState(() {
      users = List<Users>.from(data['Users'].map((x) => Users.fromJson(x)));
    });
  }

  Future<void> login(Users user) async {
    setState(() {
      _isLoading = true;
    });

    Users? matchedUser = users.firstWhere(
      (u) => u.username == user.username && u.password == user.password,
      orElse: () => Users(),
    );

    if (matchedUser.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username or password invalid")),
      );
    } else {
      Configure.login = matchedUser;
      Navigator.pushNamed(context, '/product');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget usernameInputField() {
    return TextFormField(
      focusNode: _usernameFocusNode,
      style: TextStyle(color: Colors.white), 
      cursorColor: Colors.black, 
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(
          color: _usernameFocusNode.hasFocus ? const Color.fromARGB(255, 214, 238, 241) : Colors.white,
        ),
        prefixIcon: Icon(
          Icons.person,
          color: _usernameFocusNode.hasFocus ? const Color.fromARGB(255, 214, 238, 241) : Colors.white,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      onSaved: (newValue) {
        user.username = newValue;
      },
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      obscureText: true,
      style: TextStyle(color: Colors.white), 
      cursorColor: Colors.black, 
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: _passwordFocusNode.hasFocus ? const Color.fromARGB(255, 214, 238, 241) : Colors.white,
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: _passwordFocusNode.hasFocus ? const Color.fromARGB(255, 214, 238, 241) : Colors.white,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      onSaved: (newValue) {
        user.password = newValue;
      },
    );
  }

  Widget loginButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          login(user);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), 
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5), 
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ZLEEPY",
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: usernameInputField(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: passwordInputField(),
                  ),
                  const SizedBox(height: 20),
                  loginButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}