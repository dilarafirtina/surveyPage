import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'default_button.dart';
import 'firebase_options.dart';

final Storage _localStorage = window.localStorage;
void main() async {
  setUrlStrategy(PathUrlStrategy());
  if (Uri.base.queryParameters.isNotEmpty) {
    _localStorage['roomNumber'] = Uri.base.queryParameters["roomNumber"]!;
    _localStorage['bdate'] = Uri.base.queryParameters["bdate"]!;
    _localStorage['firstname'] = Uri.base.queryParameters["firstname"]!;
    _localStorage['lastName'] = Uri.base.queryParameters["lastName"]!;
    _localStorage['nation'] = Uri.base.queryParameters["nation"]!;
  }
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Opex',
        home:
            LandingOnePage()); // TODO: Initial route olarak parametreli path ismi verilmeli mi?
  }
}

class LandingOnePage extends StatelessWidget {
  LandingOnePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/bg1.jpg",
                fit: BoxFit.contain,
              )),
          Column(
            children: <Widget>[
              SizedBox(height: 30.0),
              Expanded(
                child: Container(
                  width: 370,
                  height: 550,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(5.0, 5.0),
                            blurRadius: 5.0)
                      ]),
                  margin: EdgeInsets.all(48.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Image.asset("assets/images/bluewave.jpg")
                                    .image,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              )),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "Welcome to Blue Wave",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 24.0,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "We kindly ask your permission to contact you for getting your opinions during your stay via online satisfaction surveys.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 15.0),
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  width: double.infinity,
                  child: DefaultButton(
                    press: () async {
                      await Firebase.initializeApp(
                          options: DefaultFirebaseOptions.currentPlatform);
                      FirebaseMessaging messaging = FirebaseMessaging.instance;
                      NotificationSettings settings =
                          await messaging.requestPermission(
                        alert: true,
                        announcement: false,
                        badge: true,
                        carPlay: false,
                        criticalAlert: false,
                        provisional: false,
                        sound: true,
                      );
                      if (settings.authorizationStatus ==
                          AuthorizationStatus.authorized) {
                        final fcmToken = await FirebaseMessaging.instance.getToken(
                            vapidKey:
                                "BDxVdP075LNb1SK3y-kzvqdn-CeMvltZOWuz-y2jFxTyelYxitjfqcdwvJcHmBi6YSrZ7u_smPICBaQqVOOu6kA");
                        _localStorage['fcmToken'] = fcmToken!;

                        String surveyId =
                            '446FA727-7BA3-410A-83A1-18084FE07FD9';
                        String roomNumber = _localStorage['roomNumber']!;
                        String bdate = _localStorage['bdate']!;
                        String firstname = _localStorage['roomNumber']!;
                        String lastName = _localStorage['lastName']!;
                        String nation = _localStorage['nation']!;

                        final surveryUri =
                            'https://my.opex.app/survey/bluewave/survey.html?SurveyId=$surveyId&roomNumber=$roomNumber&bdate=$bdate&firstname=$firstname&lastName=$lastName&nation=$nation&fcmToken=$fcmToken';
                        launchInBrowser(surveryUri);
                      } else {
                        launchInBrowser('https://my.opex.app/');
                      }
                    },
                    text: "Click to Decide",
                    key: key,
                  )),
              const SizedBox(height: 40.0),
            ],
          )
        ],
      ),
    );
  }
}

Future<void> launchInBrowser(String? url) async {
  if (url == null || url == "") return;
  if (!await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.platformDefault,
    webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true, enableDomStorage: true),
  )) {
    print('Could not launch $url');
  }
}
