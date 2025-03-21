import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homejourney_appmovile/colaboradores_sucursales/bloc/colaborador_sucursal_bloc.dart';
import 'package:homejourney_appmovile/colaboradores_sucursales/bloc/sucursal_bloc.dart';
import 'package:homejourney_appmovile/home/bloc/home_event.dart';
import 'package:homejourney_appmovile/theme/app_theme.dart';
import 'package:homejourney_appmovile/viajes/bloc/viaje_bloc.dart';
import 'package:intl/intl.dart';
import 'home/home_dashboard.dart';
import 'home/bloc/home_bloc.dart';
import 'repository/data_repository.dart';
import 'login/login_page.dart';
import 'colaboradores/bloc/colaborador_bloc.dart';
import 'services/colaborador_service.dart';
import 'services/auth_service.dart';
import 'login/bloc/login_bloc.dart';
import 'services/colaborador_sucursal_service.dart';
import 'services/sucursal_service.dart';
import 'services/transportista_service.dart';
import 'services/viaje_service.dart';
import 'app_navigator.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  Intl.defaultLocale = 'es';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String baseApiUrl = 'https://172.29.6.228:45456';
    
    final dataRepository = DataRepository();
    
    final authService = AuthService(
      baseUrl: baseApiUrl,
    );
    
    final colaboradorService = ColaboradorService(
      baseUrl: baseApiUrl,
      authService: authService, 
    );
    
    final colaboradorSucursalService = ColaboradorSucursalService(
      baseUrl: baseApiUrl,
      authService: authService, 
    );
    
    final sucursalService = SucursalService(
      baseUrl: baseApiUrl,
      authService: authService, 
    );
    
    final transportistaService = TransportistaService(
      baseUrl: baseApiUrl,
      authService: authService, 
    );
    
    final viajeService = ViajeService(
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
        BlocProvider<ColaboradorSucursalBloc>(
          create: (context) => ColaboradorSucursalBloc(
            colaboradorSucursalService: colaboradorSucursalService,
          ),
        ),
        BlocProvider<SucursalBloc>(
          create: (context) => SucursalBloc(
            sucursalService: sucursalService,
          ),
        ),
        BlocProvider<ViajeBloc>(
          create: (context) => ViajeBloc(
            viajeService: viajeService,
            colaboradorSucursalService: colaboradorSucursalService,
            transportistaService: transportistaService,
            sucursalService: sucursalService,
            loginBloc: context.read<LoginBloc>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter BLoC Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const AppNavigator(),
      ),
    );
  }
}
