import 'package:flutter/material.dart';

import 'ui/views/home_page.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cloud Project',
        home: HomePage(),
        debugShowCheckedModeBanner: false); // define it once at root level.
  }
}
