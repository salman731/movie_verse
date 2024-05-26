import 'package:Movieverse/constants/app_colors.dart';
import 'package:Movieverse/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:sizer/sizer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: SettingsGroup(
        title: 'Common Settings',
        children: <Widget>[
          CheckboxSettingsTile(
            settingKey: SharedPrefsUtil.KEY_PRIMEWIRE_LOGIN,
            title: 'Enable Primewire Login',
            subtitle: "Required for adults links (App Restart Required)",
            showDivider: false,
            titleTextStyle: TextStyle(color: AppColors.red),
            leading: Icon(Icons.login,color: AppColors.red,),
            childrenIfEnabled: [
              TextInputSettingsTile(
              title: 'User Name',
              settingKey: SharedPrefsUtil.KEY_PRIMEWIRE_USERNAME,
              initialValue: '',
              titleTextStyle: TextStyle(color: AppColors.red),
              validator: (String? username) {
                if (username != null && username.isNotEmpty) {
                  return null;
                }
                return "User Name can't be empty";
              },
              onChange: (value){

              },
              borderColor: AppColors.red,
              errorColor: Colors.deepOrangeAccent,
            ),
              TextInputSettingsTile(
                title: 'Password',
                helperText: "Enter Password",
                obscureText: true,
                settingKey: SharedPrefsUtil.KEY_PRIMEWIRE_PASSWORD,
                initialValue: '',
                titleTextStyle: TextStyle(color: AppColors.red),
                validator: (String? username) {
                  if (username != null && username.isNotEmpty) {
                    return null;
                  }
                  return "Password can't be empty";
                },
                borderColor: AppColors.red,
                errorColor: Colors.deepOrangeAccent,
              )
            ],
          ),
        ],
      ),
    );

  }

  loginIntoPrimeWireFromSettings()
  {

  }
}
