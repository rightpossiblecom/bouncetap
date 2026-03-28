import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navy,
      appBar: AppBar(
        backgroundColor: AppTheme.navy,
        title: const Text('SETTINGS'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildSectionHeader('General'),
          _buildSwitchTile(
            title: 'Sound Effects',
            subtitle: 'Enable or disable in-game sounds',
            value: true,
            onChanged: (_) {},
          ),
          _buildSwitchTile(
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on tap and impact',
            value: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 8),
          _buildSectionHeader('Visuals'),
          _buildListTile(
            title: 'Ball Skin',
            subtitle: 'Change the look of your ball',
            trailing: const Icon(
              Icons.chevron_right,
              color: AppTheme.slate,
            ),
            onTap: () {},
          ),
          _buildListTile(
            title: 'Theme Mode',
            subtitle: 'Switch between light and dark mode',
            trailing: const Text(
              'System',
              style: TextStyle(
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _buildSectionHeader('About'),
          _buildListTile(
            title: 'Version',
            subtitle: '1.0.1 (Build 2)',
          ),
          _buildListTile(
            title: 'License',
            subtitle: 'MIT License',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.accent,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.deepBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1D3461)),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppTheme.lightSlate),
        ),
        value: value,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.deepBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1D3461)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppTheme.lightSlate),
        ),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
