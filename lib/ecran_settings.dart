import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../providers/user_provider.dart';
import '../viewModel/settingViewModel.dart';

class EcranSettings extends StatelessWidget {
  const EcranSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('Compte'),
          tiles: [
            SettingsTile.navigation(
              title: const Text('Déconnexion'),
              leading: const Icon(Icons.logout),
              onPressed: (BuildContext context) {
                context.read<UserProvider>().logout();
              },
            ),
          ],
        ),
        SettingsSection(
          title: const Text('Apparence'),
          tiles: [
            SettingsTile.switchTile(
              title: const Text('Mode sombre'),
              leading: const Icon(Icons.dark_mode),
              initialValue: context.watch<SettingViewModel>().isDark, // Correction: initialValue au lieu de switchValue
              onToggle: (value) {
                context.read<SettingViewModel>().isDark = value;
              },
            ),
          ],
        ),
      ],
    );
  }
}