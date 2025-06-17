import 'package:flutter/cupertino.dart';
//import 'main.dart';
import 'login_page.dart';
import 'signup_page.dart';
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginPage(onSignupTap: () => setState(() => showLogin = false), onSignUpTap: () {  },)
        : SignupPage(onLoginTap: () => setState(() => showLogin = true));
  }
}
