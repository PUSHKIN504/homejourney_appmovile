import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'Español';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Apariencia
            _buildSectionHeader('Apariencia'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Modo Oscuro'),
                    subtitle: const Text('Activar tema oscuro en la aplicación'),
                    value: _darkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                    },
                    secondary: const Icon(Icons.dark_mode),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Idioma'),
                    subtitle: Text(_selectedLanguage),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showLanguageDialog();
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.text_fields),
                    title: const Text('Tamaño de Texto'),
                    subtitle: const Text('Normal'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Mostrar opciones de tamaño de texto
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Sección de Notificaciones
            _buildSectionHeader('Notificaciones'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Notificaciones Push'),
                    subtitle: const Text('Recibir notificaciones en tiempo real'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    secondary: const Icon(Icons.notifications),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Notificaciones por Email'),
                    subtitle: const Text('Diariamente'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Configurar notificaciones por email
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.do_not_disturb_on),
                    title: const Text('No Molestar'),
                    subtitle: const Text('Desactivado'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Configurar modo no molestar
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Sección de Seguridad
            _buildSectionHeader('Seguridad'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Cambiar Contraseña'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Cambiar contraseña
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Autenticación Biométrica'),
                    subtitle: const Text('Usar huella digital o reconocimiento facial'),
                    value: _biometricEnabled,
                    onChanged: (value) {
                      setState(() {
                        _biometricEnabled = value;
                      });
                    },
                    secondary: const Icon(Icons.fingerprint),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Autenticación de Dos Factores'),
                    subtitle: const Text('Desactivado'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Configurar 2FA
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Sección de Datos y Almacenamiento
            _buildSectionHeader('Datos y Almacenamiento'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('Almacenamiento'),
                    subtitle: const Text('250 MB utilizados'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Ver detalles de almacenamiento
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Limpiar Caché'),
                    subtitle: const Text('50 MB'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Limpiar caché
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('Descargas'),
                    subtitle: const Text('Gestionar archivos descargados'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Ver descargas
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Sección de Acerca de
            _buildSectionHeader('Acerca de'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Información de la App'),
                    subtitle: const Text('Versión 1.0.0'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Ver información de la app
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Ayuda y Soporte'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Ver ayuda y soporte
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Política de Privacidad'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Ver política de privacidad
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Términos y Condiciones'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Ver términos y condiciones
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Español'),
            _buildLanguageOption('English'),
            _buildLanguageOption('Français'),
            _buildLanguageOption('Deutsch'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return RadioListTile<String>(
      title: Text(language),
      value: language,
      groupValue: _selectedLanguage,
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value!;
        });
        Navigator.pop(context);
      },
    );
  }
}

