import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads/features/home/pages/home_page.dart';

import 'core/providers/post_provider.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: MaterialApp(
        home: MaterialApp(
          title: 'Threads',
          theme: ThemeData
              .dark() /* ThemeData(
            useMaterial3: true,
            fontFamily: 'Shabnam',
            colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: Color(0xFF90CAF9),
              onPrimary: Colors.black,
              primaryContainer: Color(0xFF0D47A1),
              onPrimaryContainer: Color(0xFFBBDEFB),
              secondary: Color(0xFF42A5F5),
              onSecondary: Colors.black,
              secondaryContainer: Color(0xFF1565C0),
              onSecondaryContainer: Color(0xFFBBDEFB),
              tertiary: Color(0xFF81C784),
              onTertiary: Colors.black,
              tertiaryContainer: Color(0xFF388E3C),
              onTertiaryContainer: Color(0xFFC8E6C9),
              surface: Color.fromARGB(255, 21, 21, 21),
              onSurface: Color(0xFFE0E0E0),
              onSurfaceVariant: Color(0xFFB0BEC5),
              surfaceContainer: Color(0xFF2B2B2B),
              outline: Color(0xFF90A4AE),
              error: Color(0xFFCF6679),
              onError: Colors.black,
              errorContainer: Color(0xFFB00020),
              onErrorContainer: Color(0xFFFFDAD4),
              inverseSurface: Color(0xFFE0E0E0),
              onInverseSurface: Color(0xFF303030),
              inversePrimary: Color(0xFF0D47A1),
              shadow: Colors.black,
              scrim: Colors.black54,
              surfaceTint: Color(0xFF90CAF9),
            ),
          ) */
          ,
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ),
      ),
    );
  }
}
