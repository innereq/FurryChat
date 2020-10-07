import 'dart:io';

import 'package:furrychat/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:furrychat/components/adaptive_page_layout.dart';
import 'package:furrychat/components/matrix.dart';
import 'package:image_picker/image_picker.dart';

import 'package:furrychat/components/theme_switcher.dart';

class ThemesSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: Settings(),
      secondScaffold: ThemesSettings(),
    );
  }
}

class ThemesSettings extends StatefulWidget {
  @override
  _ThemesSettingsState createState() => _ThemesSettingsState();
}

class _ThemesSettingsState extends State<ThemesSettings> {
  Themes _selectedTheme;
  bool _amoledEnabled;

  void setWallpaperAction(BuildContext context) async {
    final wallpaper = await ImagePicker().getImage(source: ImageSource.gallery);
    if (wallpaper == null) return;
    Matrix.of(context).wallpaper = File(wallpaper.path);
    await Matrix.of(context)
        .store
        .setItem('chat.fluffy.wallpaper', wallpaper.path);
    setState(() => null);
  }

  void deleteWallpaperAction(BuildContext context) async {
    Matrix.of(context).wallpaper = null;
    await Matrix.of(context).store.setItem('chat.fluffy.wallpaper', null);
    setState(() => null);
  }

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix.of(context);
    final themeEngine = ThemeSwitcherWidget.of(context);
    _selectedTheme = themeEngine.selectedTheme;
    _amoledEnabled = themeEngine.amoledEnabled;

    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).changeTheme)),
      body: ListView(children: [
        Column(
          children: <Widget>[
            RadioListTile<Themes>(
              title: Text(
                L10n.of(context).systemTheme,
              ),
              value: Themes.system,
              groupValue: _selectedTheme,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (Themes value) {
                setState(() {
                  _selectedTheme = value;
                  themeEngine.switchTheme(matrix, value, _amoledEnabled);
                });
              },
            ),
            RadioListTile<Themes>(
              title: Text(
                L10n.of(context).lightTheme,
              ),
              value: Themes.light,
              groupValue: _selectedTheme,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (Themes value) {
                setState(() {
                  _selectedTheme = value;
                  themeEngine.switchTheme(matrix, value, _amoledEnabled);
                });
              },
            ),
            RadioListTile<Themes>(
              title: Text(
                L10n.of(context).darkTheme,
              ),
              value: Themes.dark,
              groupValue: _selectedTheme,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (Themes value) {
                setState(() {
                  _selectedTheme = value;
                  themeEngine.switchTheme(matrix, value, _amoledEnabled);
                });
              },
            ),
            ListTile(
              title: Text(
                L10n.of(context).useAmoledTheme,
              ),
              trailing: Switch(
                value: _amoledEnabled,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) {
                  setState(() {
                    _amoledEnabled = value;
                    themeEngine.switchTheme(matrix, _selectedTheme, value);
                  });
                },
              ),
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
