import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/adaptive_page_layout.dart';
import '../../components/matrix.dart';
import '../../config/setting_keys.dart';
import '../settings.dart';

class ThemesSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: Settings(currentSetting: SettingsViews.themes),
      secondScaffold: ThemesSettings(),
    );
  }
}

class ThemesSettings extends StatefulWidget {
  @override
  _ThemesSettingsState createState() => _ThemesSettingsState();
}

class _ThemesSettingsState extends State<ThemesSettings> {
  void setWallpaperAction(BuildContext context) async {
    final wallpaper = await ImagePicker().getImage(source: ImageSource.gallery);
    if (wallpaper == null) return;
    Matrix.of(context).wallpaper = File(wallpaper.path);
    await Matrix.of(context)
        .store
        .setItem(SettingKeys.wallpaper, wallpaper.path);
    setState(() => null);
  }

  void deleteWallpaperAction(BuildContext context) async {
    Matrix.of(context).wallpaper = null;
    await Matrix.of(context).store.deleteItem(SettingKeys.wallpaper);
    setState(() => null);
  }

  AdaptiveThemeMode _currentTheme;

  void _switchTheme(AdaptiveThemeMode newTheme, BuildContext context) {
    switch (newTheme) {
      case AdaptiveThemeMode.light:
        AdaptiveTheme.of(context).setLight();
        break;
      case AdaptiveThemeMode.dark:
        AdaptiveTheme.of(context).setDark();
        break;
      case AdaptiveThemeMode.system:
        AdaptiveTheme.of(context).setSystem();
        break;
    }
    setState(() => _currentTheme = newTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).changeTheme)),
      body: ListView(children: [
        Column(
          children: <Widget>[
            RadioListTile<AdaptiveThemeMode>(
              groupValue: _currentTheme,
              value: AdaptiveThemeMode.system,
              title: Text(L10n.of(context).systemTheme),
              onChanged: (t) => _switchTheme(t, context),
            ),
            RadioListTile<AdaptiveThemeMode>(
              groupValue: _currentTheme,
              value: AdaptiveThemeMode.light,
              title: Text(L10n.of(context).lightTheme),
              onChanged: (t) => _switchTheme(t, context),
            ),
            RadioListTile<AdaptiveThemeMode>(
              groupValue: _currentTheme,
              value: AdaptiveThemeMode.dark,
              title: Text(L10n.of(context).darkTheme),
              onChanged: (t) => _switchTheme(t, context),
            ),
          ],
        ),
        //if (!kIsWeb && Matrix.of(context).store != null) Divider(thickness: 1),
        //if (!kIsWeb && Matrix.of(context).store != null)
        ListTile(
          title: Text(
            L10n.of(context).wallpaper,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (Matrix.of(context).wallpaper != null)
          ListTile(
            title: Image.file(
              Matrix.of(context).wallpaper,
              height: 38,
              fit: BoxFit.cover,
            ),
            trailing: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onTap: () => deleteWallpaperAction(context),
          ),
        //if (!kIsWeb && Matrix.of(context).store != null)
        Builder(builder: (context) {
          return ListTile(
            title: Text(L10n.of(context).changeWallpaper),
            trailing: Icon(Icons.wallpaper),
            onTap: () => setWallpaperAction(context),
          );
        }),
      ]),
    );
  }
}
