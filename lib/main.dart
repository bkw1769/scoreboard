// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard/providers/settings_provider.dart';
import 'package:scoreboard/providers/timer_provider.dart';
import 'providers/scoreboard_provider.dart';
import 'screens/scoreboard_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScoreboardProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Scoreboard',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        home: SafeArea(child: ScoreboardScreen()),
      ),
    );
  }
}
