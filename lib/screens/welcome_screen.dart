// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firechat/components/CuteButton.dart';
import 'package:firechat/constants.dart';
class WelcomeScreen extends StatefulWidget {
   static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController? controller;
  Animation? animation;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      upperBound: 1,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller!);
    controller!.forward();


    controller!.addListener(() {
      setState(() {

      });
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60,
                    ),
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText(
                    'Fire Chat',
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                      speed: const Duration(milliseconds: 100)
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            CuteButton(
              text: 'Log In',
              pressed: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },
              color: kButtonLightBlue,
            ),
            CuteButton(
              color: kButtonBlue,
              text: 'Register',
              pressed: (){
                Navigator.of(context).pushNamed(RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

