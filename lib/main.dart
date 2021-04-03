import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:me_poupe/pages/splash_tela.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Me Poupe',
            theme: ThemeData(
                primaryColor: Colors.purple,
                primarySwatch: Colors.orange,
                accentColor: Colors.orange,
                fontFamily: 'Quicksand',
                textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                    ),
                    button: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                    ),
                ),
                appBarTheme: AppBarTheme(
                    textTheme: ThemeData.light().textTheme.copyWith(
                        headline6: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        )
                    )
                ),
            ),
            home: SplashTela(),
            localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: [const Locale('pt', 'BR')],
        );
    }
}
