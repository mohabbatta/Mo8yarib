import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mo8tarib/landing_page.dart';
import 'package:mo8tarib/helper/localization.dart';
import 'package:mo8tarib/services/app_language.dart';
import 'package:mo8tarib/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_)=>appLanguage,
      child: Consumer<AppLanguage>(
        builder: (context,model,child){
          print(model.appLocal);
          return MaterialApp(
            locale: model.appLocal,
          supportedLocales: [
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            title: 'Mo8trab',
            theme: ThemeData(primaryColor: Colors.white),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              bottomNavigationBarTheme:
              BottomNavigationBarThemeData(backgroundColor: Colors.black54)
            ),
            home: FutureBuilder(
              // Initialize FlutterFire:
              future: _initialization,
              builder: (context, snapshot) {
                // Check for errors
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Scaffold(
                      body: Container(
                        child: Center(
                          child: Text('something error'),
                        ),
                      ));
                }

                // Once complete, show your application
                if (snapshot.connectionState == ConnectionState.done) {
                  return  Provider<AuthBase>(
                    create: (context) => Auth(),
                    child: LandingPage(),
                  );

                }

                // Otherwise, show something whilst waiting for initialization to complete
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
