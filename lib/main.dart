import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mo8tarib/Screen/login.dart';
import 'package:mo8tarib/Screen/edit_user.dart';
import 'package:mo8tarib/localization.dart';
import 'package:mo8tarib/model/languageControler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/home.dart';
import 'Screen/sign_up.dart';
import 'model/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  static Future<bool>getEmail()async{

    SharedPreferences _shard=await SharedPreferences.getInstance();
    String email= _shard.getString("email");
    if(email==null){
      return false;
    }else {return true;}

  }

  @override
  void didChangeDependencies() {
    languageControler controler = new languageControler();
    controler.getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        title: "Mo8tarib",
        locale: _locale,
        supportedLocales: [
          Locale('fr'),
          Locale('ar', 'SA'),
          Locale('en', 'UK'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,

        home: EditUser()
//        getEmail() == false? SignUp():home(new User('',0,{'fname':'tata','lname':'nana'},
//            'male','',[],'tt')),

      );
    }
  }
}
