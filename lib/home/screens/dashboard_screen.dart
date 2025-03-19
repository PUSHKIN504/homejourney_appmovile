import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../login/bloc/login_state.dart';
import '../../login/bloc/login_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener información del usuario desde el estado de login
    final loginState = context.read<LoginBloc>().state;
    String userName = 'Usuario';
    
    if (loginState is LoginSuccess) {
      userName = loginState.nombre ?? loginState.username;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta de bienvenida
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 24,
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¡Bienvenido, $userName!',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Última sesión: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Resumen del día',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tienes 3 tareas pendientes y 2 reuniones programadas para hoy.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Estadísticas
          const Text(
            'Estadísticas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                context,
                'Colaboradores',
                '24',
                Icons.people,
                Colors.blue,
              ),
              _buildStatCard(
                context,
                'Tareas',
                '12',
                Icons.task,
                Colors.green,
              ),
              _buildStatCard(
                context,
                'Proyectos',
                '5',
                Icons.work,
                Colors.orange,
              ),
              _buildStatCard(
                context,
                'Notificaciones',
                '8',
                Icons.notifications,
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Actividad reciente
          const Text(
            'Actividad Reciente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getRandomColor(index),
                    child: Icon(
                      _getRandomIcon(index),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    _getActivityTitle(index),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Hace ${index + 1} ${index == 0 ? 'hora' : 'horas'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navegar a la actividad
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          
          // Próximas tareas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Próximas Tareas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Ver todas las tareas
                },
                child: const Text('Ver todas'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: false,
                  onChanged: (value) {
                    // Marcar tarea como completada
                  },
                  title: Text(
                    _getTaskTitle(index),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Vence el ${DateTime.now().day + index + 1}/${DateTime.now().month}/${DateTime.now().year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  secondary: Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getTaskPriorityColor(index),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getRandomColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];
    return colors[index % colors.length];
  }

  IconData _getRandomIcon(int index) {
    final icons = [
      Icons.person_add,
      Icons.edit,
      Icons.file_upload,
      Icons.comment,
      Icons.task_alt,
    ];
    return icons[index % icons.length];
  }

  String _getActivityTitle(int index) {
    final activities = [
      'Juan Pérez agregó un nuevo colaborador',
      'María López editó un documento',
      'Carlos Rodríguez subió un archivo',
      'Ana García comentó en una tarea',
      'Pedro Martínez completó una tarea',
    ];
    return activities[index % activities.length];
  }

  String _getTaskTitle(int index) {
    final tasks = [
      'Revisar informes mensuales',
      'Preparar presentación para reunión',
      'Actualizar base de datos de clientes',
    ];
    return tasks[index % tasks.length];
  }

  Color _getTaskPriorityColor(int index) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.green,
    ];
    return colors[index % colors.length];
  }
}

