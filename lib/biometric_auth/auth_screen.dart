import 'package:flutter/material.dart';
import 'package:jakes_git_app/home_screen/home_screen.dart';
import 'package:jakes_git_app/repository/api_client.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  ApiClient apiClient = ApiClient();
  late bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authetication Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)),
          onPressed: () async {
            //make sure to add finger print to your device before using.
            this.isAuthenticated = await this.apiClient.authenticate();

            if (!isAuthenticated) {
              print('false');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Authentication Failed'),
                  backgroundColor: Colors.red,
                  elevation: 2.0,
                ),
              );
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Jake()));
            }
          },
          child: Text('Authenticate with Fingerprint'),
        ),
      ),
    );
  }
}
