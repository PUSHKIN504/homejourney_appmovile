import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homejourney_appmovile/colaboradores_sucursales/colaborador_sucursal_list_screen.dart';
import 'login/bloc/login_bloc.dart';
import 'login/bloc/login_state.dart';
import 'login/login_page.dart';
import 'home/screens/dashboard_screen.dart';
import 'colaboradores/colaborador_list_screen.dart';
import 'home/screens/notifications_screen.dart';
import 'home/screens/profile_screen.dart';
import 'widgets/bottom_navigation_menu.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const ColaboradorListScreen(),
    const ColaboradorSucursalListScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        // Si no está autenticado, mostrar la pantalla de login
        if (state is! LoginSuccess) {
          return const LoginPage();
        }
        
        // Si está autenticado, mostrar la aplicación con el menú de navegación
        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationMenu(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}

