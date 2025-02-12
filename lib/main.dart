import 'package:flutter/material.dart';
import 'package:prequalification/providers/address_provider.dart';
import 'package:prequalification/providers/qualification_provider.dart';
import 'package:prequalification/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => QualificationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Address Qualification',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
