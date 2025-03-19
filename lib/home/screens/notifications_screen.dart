import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notificaciones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Marcar todas como leídas
                },
                icon: const Icon(Icons.done_all, size: 16),
                label: const Text('Marcar todas como leídas'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(context, 'Todas', true),
                _buildFilterChip(context, 'No leídas', false),
                _buildFilterChip(context, 'Importantes', false),
                _buildFilterChip(context, 'Tareas', false),
                _buildFilterChip(context, 'Mensajes', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Lista de notificaciones
          Expanded(
            child: _buildNotificationsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (value) {
          // Cambiar filtro
        },
        backgroundColor: Theme.of(context).cardColor,
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        checkmarkColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    final notifications = [
      _NotificationItem(
        title: 'Nueva tarea asignada',
        message: 'Se te ha asignado la tarea "Revisar informes mensuales"',
        time: 'Hace 10 minutos',
        icon: Icons.task,
        color: Colors.blue,
        isRead: false,
      ),
      _NotificationItem(
        title: 'Reunión programada',
        message: 'Recordatorio: Reunión de equipo mañana a las 9:00 AM',
        time: 'Hace 30 minutos',
        icon: Icons.event,
        color: Colors.green,
        isRead: false,
      ),
      _NotificationItem(
        title: 'Comentario en documento',
        message: 'María López comentó en el documento "Propuesta de proyecto"',
        time: 'Hace 1 hora',
        icon: Icons.comment,
        color: Colors.orange,
        isRead: true,
      ),
      _NotificationItem(
        title: 'Actualización de sistema',
        message: 'Se ha completado la actualización del sistema a la versión 2.5',
        time: 'Hace 2 horas',
        icon: Icons.system_update,
        color: Colors.purple,
        isRead: true,
      ),
      _NotificationItem(
        title: 'Nuevo colaborador',
        message: 'Juan Pérez ha sido agregado como colaborador',
        time: 'Hace 3 horas',
        icon: Icons.person_add,
        color: Colors.teal,
        isRead: true,
      ),
    ];

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 16),
            const Text(
              'No tienes notificaciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Las notificaciones aparecerán aquí',
              style: TextStyle(
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: notification.color.withOpacity(0.2),
            child: Icon(
              notification.icon,
              color: notification.color,
              size: 20,
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: notification.isRead
                  ? null
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 14,
                  color: notification.isRead
                      ? Colors.grey.shade400
                      : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                notification.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
          trailing: notification.isRead
              ? null
              : Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          onTap: () {
            // Ver detalle de notificación
          },
        );
      },
    );
  }
}

class _NotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  final bool isRead;

  _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    required this.isRead,
  });
}

