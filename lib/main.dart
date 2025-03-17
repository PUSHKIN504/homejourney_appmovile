import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homejourney_appmovile/home/bloc/home_event.dart';
import 'package:homejourney_appmovile/utils/httpoverrides';
import 'home/home_page.dart';
import 'home/bloc/home_bloc.dart';
import 'repository/data_repository.dart';
import 'login/login_page.dart';
import 'colaboradores/bloc/colaborador_bloc.dart';
import 'services/colaborador_service.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dataRepository = DataRepository();
    
    final colaboradorService = ColaboradorService(
      baseUrl: 'https://172.29.6.105:45456', 
    );
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) =>
              HomeBloc(dataRepository: dataRepository)..add(LoadHomeData()),
        ),
        BlocProvider<ColaboradorBloc>(
          create: (context) => ColaboradorBloc(
            colaboradorService: colaboradorService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter BLoC Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.teal,
          colorScheme: const ColorScheme.dark(
            primary: Colors.teal,
            secondary: Colors.tealAccent,
            surface: Color(0xFF1E1E1E),
            background: Color(0xFF121212),
          ),
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardColor: const Color(0xFF1E1E1E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.grey.shade400),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.teal, width: 2),
            ),
          ),
        ),
        themeMode: ThemeMode.dark, // Force dark theme
        home: const LoginPage(), // Start with login page
      ),
    );
  }
}
