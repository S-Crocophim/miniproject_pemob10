// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';
import '/firebase_options.dart';
import '/providers/auth_provider.dart';
import '/providers/cold_room_provider.dart';
import '/providers/theme_provider.dart'; // Import
import '/screens/dashboard_screen.dart';
import '/screens/login_screen.dart';
import '/utils/app_theme.dart'; // Import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ColdRoomProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Tambahkan ThemeProvider
      ],
      // Gunakan Consumer untuk mendengarkan perubahan tema
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Cold Room Monitoring',
            // Gunakan tema dari provider
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.hasData) {
                  return const DashboardScreen();
                }
                return const LoginScreen();
              },
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}