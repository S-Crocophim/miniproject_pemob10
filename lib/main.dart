// lib/main.dart
import 'package:miniproject_pemob10/providers/auth_provider.dart';
import 'package:miniproject_pemob10/providers/cold_room_provider.dart';
import 'package:miniproject_pemob10/screens/dashboard_screen.dart';
import 'package:miniproject_pemob10/screens/login_screen.dart';
import 'package:miniproject_pemob10/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
      ],
      child: MaterialApp(
        title: 'Cold Room Monitoring',
        theme: AppTheme.theme,
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isLoggedIn) {
              return const DashboardScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
