import 'package:flutter/material.dart';
import 'package:flutter_application_8/models/login.dart'; 

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0), 
              child: Text(
                "ZLEEPY",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.8),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Icon(
                Icons.arrow_forward,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
