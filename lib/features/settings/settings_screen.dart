import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        children: [
          _buildSectionHeader('General', context),
          _buildSwitchTile(
            title: 'Sound Effects',
            subtitle: 'Enable or disable in-game sounds',
            value: true,
            onChanged: (_) {},
            context: context,
          ),
          _buildSwitchTile(
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on tap and impact',
            value: true,
            onChanged: (_) {},
            context: context,
          ),
          const Divider(),
          _buildSectionHeader('Visuals', context),
          _buildListTile(
            title: 'Ball Skin',
            subtitle: 'Change the look of your ball',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
            context: context,
          ),
          _buildListTile(
            title: 'Theme Mode',
            subtitle: 'Switch between light and dark mode',
            trailing: const Text('System'),
            onTap: () {},
            context: context,
          ),
          const Divider(),
          _buildSectionHeader('About', context),
          _buildListTile(
            title: 'Version',
            subtitle: '1.0.0 (Build 1)',
            context: context,
          ),
          _buildListTile(
            title: 'License',
            subtitle: 'MIT License',
            onTap: () {},
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required BuildContext context,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
