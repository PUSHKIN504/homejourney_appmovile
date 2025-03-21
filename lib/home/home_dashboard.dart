import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homejourney_appmovile/colaboradores/bloc/colaborador_bloc.dart';
import 'package:homejourney_appmovile/colaboradores/bloc/colaborador_event.dart';
import 'package:homejourney_appmovile/colaboradores/colaborador_form_screen.dart';
import 'package:homejourney_appmovile/colaboradores_sucursales/bloc/colaborador_sucursal_bloc.dart';
import 'package:homejourney_appmovile/colaboradores_sucursales/bloc/colaborador_sucursal_event.dart';
import 'package:homejourney_appmovile/colaboradores_sucursales/colaborador_sucursal_form_screen.dart';
import 'package:homejourney_appmovile/colaboradores_sucursales/colaborador_sucursal_list_screen.dart';
import 'package:homejourney_appmovile/login/bloc/login_event.dart';
import '../login/bloc/login_state.dart';
import '../login/bloc/login_bloc.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notifications_screen.dart';
import '../colaboradores/colaborador_list_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const ColaboradorListScreen(),
    const ColaboradorSucursalListScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final loginState = context.read<LoginBloc>().state;
    String userName = 'Usuario';
    String userRole = 'Invitado';
    
    if (loginState is LoginSuccess) {
      userName = loginState.nombre ?? loginState.username;
      userRole = loginState.rolNombre ?? 'Usuario';
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                userRole,
                style: TextStyle(
                  color: Colors.grey.shade300,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
              selected: _currentIndex == 0,
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Colaboradores'),
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
              selected: _currentIndex == 1,
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Asignación a Sucursales'),
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
              selected: _currentIndex == 2,
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificaciones'),
              onTap: () {
                setState(() => _currentIndex = 3);
                Navigator.pop(context);
              },
              selected: _currentIndex == 3,
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                setState(() => _currentIndex = 4);
                Navigator.pop(context);
              },
              selected: _currentIndex == 4,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cerrar Sesión'),
                    content: const Text('¿Está seguro que desea cerrar sesión?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<LoginBloc>().add(LoginReset());
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Cerrar Sesión'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      appBar: AppBar(
        title: _getAppBarTitle(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          if (_currentIndex == 0 || _currentIndex == 1 || _currentIndex == 2)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
              },
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width,
                  kToolbarHeight,
                  0,
                  0,
                ),
                items: [
                  const PopupMenuItem(
                    value: 'help',
                    child: Row(
                      children: [
                        Icon(Icons.help_outline, size: 20),
                        SizedBox(width: 8),
                        Text('Ayuda'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'about',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 20),
                        SizedBox(width: 8),
                        Text('Acerca de'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Colaboradores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Sucursales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  Widget? _getFloatingActionButton() {
    switch (_currentIndex) {
      case 1: 
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ColaboradorFormScreen(),
              ),
            ).then((_) {
              if (_currentIndex == 1 && _screens[1] is ColaboradorListScreen) {
                context.read<ColaboradorBloc>().add(LoadColaboradores());
              }
            });
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add),
        );
      case 2: 
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ColaboradorSucursalFormScreen(),
              ),
            ).then((_) {
              if (_currentIndex == 2 && _screens[2] is ColaboradorSucursalListScreen) {
                context.read<ColaboradorSucursalBloc>().add(LoadColaboradoresSucursales());
              }
            });
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add),
        );
      default:
        return null;
    }
  }

  Widget _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return const Text('Dashboard');
      case 1:
        return const Text('Colaboradores');
      case 2:
        return const Text('Asignación a Sucursales');
      case 3:
        return const Text('Notificaciones');
      case 4:
        return const Text('Perfil');
      default:
        return const Text('App');
    }
  }
}

