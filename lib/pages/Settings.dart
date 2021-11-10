import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          titleTextStyle: TextStyle(
            color: Color(0xFF135BFF)
          ),
          titlePadding: EdgeInsets.all(16.0),
          title: 'Относно приложението',
          tiles: [
            SettingsTile(
              title: 'Версия',
              subtitle: 'v1.0.5+1, 10.11.2021г.',
              leading: Icon(Icons.code_rounded),
            ),
            // SettingsTile(
            //   title: 'Разработчик',
            //   subtitle: 'Stf Kolev',
            //   leading: Icon(Icons.code),
            // )
          ]
        )
      ]
    );
  }
}