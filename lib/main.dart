import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homejourney_appmovile/home/bloc/home_event.dart';
import 'home/home_page.dart';
import 'home/bloc/home_bloc.dart';
import 'repository/data_repository.dart';
import 'login/login_page.dart';
import 'colaboradores/bloc/colaborador_bloc.dart';
import 'services/colaborador_service.dart';
import 'services/auth_service.dart';
import 'login/bloc/login_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String baseApiUrl = 'https://172.29.6.105:45456'; // Reemplaza con tu URL real
    final dataRepository = DataRepository();
    
    final authService = AuthService(
      baseUrl: baseApiUrl,
    );
    
    final colaboradorService = ColaboradorService(
      baseUrl: baseApiUrl,
      authService: authService,
    );
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(dataRepository: dataRepository)..add(LoadHomeData()),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            authService: authService,
          ),
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
        themeMode: ThemeMode.dark,
        home: const LoginPage(),
      ),
    );
  }
}

