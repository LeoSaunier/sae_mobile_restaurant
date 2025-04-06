import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sae_restaurant/modele/settingRepositery.dart';
import 'package:sae_restaurant/viewModel/settingViewModel.dart';
import 'package:provider/provider.dart';


class EcranSettings extends StatefulWidget{
  @override
  State<EcranSettings> createState() => _EcranSettingsState();
}

class _EcranSettingsState extends State<EcranSettings> {
  bool _dark = false;

  @override
  void initState(){
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async{
    bool settings = context.read<SettingViewModel>().isDark;
    setState(() {
      _dark = settings;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SettingsList(
        sections: [
          SettingsSection(
            title: Text("Theme"),
            tiles: [
              SettingsTile.switchTile(
                  initialValue: _dark,
                  title: Text('DarkMode'),
                  onToggle: _onToggle,
              ),
              SettingsTile(title: Text('Police'))
            ]
          ),
        ]
    );
  }

  _onToggle(bool value) {
    //debugPrint('value $value');
    setState(() {
      _dark = !_dark;
      context.read<SettingViewModel>().isDark = _dark;
    });
  }
}