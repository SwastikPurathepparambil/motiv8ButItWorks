import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      print('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        builder: Authenticator.builder(),
        home: HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Auth vNext')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              FutureBuilder(
                future: Amplify.Auth.fetchUserAttributes(),
                builder:
                    (context, AsyncSnapshot<List<AuthUserAttribute>> snapshot) {
                  if (snapshot.data == null) {
                    return  Center(child: Text('loading ...'));
                  }
                  var userIndex = snapshot.data?.indexWhere((element) => element.userAttributeKey == CognitoUserAttributeKey.name).toInt();
                  var username = snapshot.data?[userIndex!].value;
                  return Column(
                    children: [
                      Text(username!),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),
              SignOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
