import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';

//How to recreate + Important Information
// Requirements: you should have a device that you can use and flutter on you computer
// Step 1: complete the getting started described here: https://docs.amplify.aws/lib/project-setup/create-application/q/platform/flutter/#4-initialize-amplify-in-the-application
// Step 2: follow the steps for social sign in with webUI: https://docs.amplify.aws/lib/auth/social_signin_web_ui/q/platform/flutter/#android-platform-setup
// Step 3: Run the code from this main.dart on a device
// Important Information: The FutureBuilder gives frontend developers the ability to
// access user information if they are logged in: https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html


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
      appBar: AppBar(title: Text('Authentication Results')),
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
