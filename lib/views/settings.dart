import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:furrychat/utils/platform_infos.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';
import '../components/matrix.dart';
import '../config/setting_keys.dart';

enum SettingsViews {
  account,
  homeserver,
  style,
  chat,
  emotes,
  encryption,
  devices,
  notifications,
  thridpid,
}

class Settings extends StatefulWidget {
  final bool isInFocus;
  final SettingsViews currentSetting;

  const Settings({this.isInFocus = false, this.currentSetting, Key key})
      : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<dynamic> profileFuture;
  dynamic profile;

  void _setAppLockAction(BuildContext context) async {
    final currentLock =
        await FlutterSecureStorage().read(key: SettingKeys.appLockKey);
    if (currentLock?.isNotEmpty ?? false) {
      var unlocked = false;
      await showLockScreen(
        context: context,
        correctString: currentLock,
        onUnlocked: () => unlocked = true,
        canBiometric: true,
      );
      if (unlocked != true) return;
    }
    final newLock = await showTextInputDialog(
      context: context,
      title: L10n.of(context).pleaseChooseAPasscode,
      message: L10n.of(context).pleaseEnter4Digits,
      textFields: [
        DialogTextField(
          validator: (text) {
            if (text.length != 4 && text.isNotEmpty) {
              return L10n.of(context).pleaseEnter4Digits;
            }
            return null;
          },
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLines: 1,
          minLines: 1,
        )
      ],
    );
    if (newLock != null) {
      await FlutterSecureStorage()
          .write(key: SettingKeys.appLockKey, value: newLock.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    profileFuture ??= client.ownProfile.then((p) {
      if (mounted) setState(() => profile = p);
      return p;
    });
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverAppBar(
            leading: !widget.isInFocus
                ? IconButton(
                    icon: Icon(Icons.close_outlined),
                    onPressed: () =>
                        {Navigator.of(context).popUntil((r) => r.isFirst)},
                  )
                : null,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).appBarTheme.color,
            title: Text(L10n.of(context).settings),
          ),
        ],
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.person_outlined,
              ),
              title: Text(profile?.displayname ?? L10n.of(context).account),
              selected:
                  widget.currentSetting == SettingsViews.account ? true : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              subtitle: Text(client.userID),
              onTap: () =>
                  AdaptivePageLayout.of(context).pushNamed('/settings/account'),
            ),
            ListTile(
              leading: Icon(
                Icons.dns_outlined,
              ),
              title: Text(L10n.of(context).homeserver),
              selected: widget.currentSetting == SettingsViews.homeserver
                  ? true
                  : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              subtitle: Text(client.homeserver.host),
              onTap: () => AdaptivePageLayout.of(context)
                  .pushNamed('/settings/homeserver'),
            ),
            Divider(thickness: 1),
            ListTile(
              leading: Icon(
                Icons.color_lens_outlined,
              ),
              title: Text(L10n.of(context).changeTheme),
              selected:
                  widget.currentSetting == SettingsViews.style ? true : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              onTap: () =>
                  AdaptivePageLayout.of(context).pushNamed('/settings/style'),
            ),
            ListTile(
              leading: Icon(
                Icons.chat_outlined,
              ),
              title: Text(L10n.of(context).chat),
              selected:
                  widget.currentSetting == SettingsViews.chat ? true : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              onTap: () =>
                  AdaptivePageLayout.of(context).pushNamed('/settings/chat'),
            ),
            ListTile(
              leading: Icon(
                Icons.insert_emoticon_outlined,
              ),
              title: Text(L10n.of(context).emoteSettings),
              selected:
                  widget.currentSetting == SettingsViews.emotes ? true : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              onTap: () =>
                  AdaptivePageLayout.of(context).pushNamed('/settings/emotes'),
            ),
            ListTile(
              leading: Icon(
                Icons.lock_outline,
              ),
              title: Text(L10n.of(context).encryption),
              selected: widget.currentSetting == SettingsViews.encryption
                  ? true
                  : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              onTap: () => AdaptivePageLayout.of(context)
                  .pushNamed('/settings/encryption'),
            ),
            if (PlatformInfos.isMobile)
                ListTile(
                  trailing: Icon(Icons.pan_tool_outlined),
                  title: Text(L10n.of(context).appLock),
                  onTap: () => _setAppLockAction(context),
                ),
            ListTile(
              leading: Icon(
                Icons.notifications_outlined,
              ),
              title: Text(L10n.of(context).notifications),
              selected: widget.currentSetting == SettingsViews.notifications
                  ? true
                  : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              onTap: () => AdaptivePageLayout.of(context)
                  .pushNamed('/settings/notifications'),
            ),
            ListTile(
              leading: Icon(
                Icons.devices_other_outlined,
              ),
              title: Text(L10n.of(context).devices),
              selected:
                  widget.currentSetting == SettingsViews.devices ? true : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              onTap: () =>
                  AdaptivePageLayout.of(context).pushNamed('/settings/devices'),
            ),
            Divider(thickness: 1),
            ListTile(
              leading: Icon(
                Icons.help_outline_outlined,
              ),
              title: Text(L10n.of(context).help),
              onTap: () => launch(AppConfig.supportUrl),
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip_outlined,
              ),
              title: Text(L10n.of(context).privacy),
              onTap: () => launch(AppConfig.privacyUrl),
            ),
            ListTile(
              leading: Icon(
                Icons.link_outlined,
              ),
              title: Text(L10n.of(context).license),
              onTap: () => showLicensePage(
                context: context,
                applicationIcon:
                    Image.asset('assets/logo.png', width: 100, height: 100),
                applicationName: AppConfig.applicationName,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.code_outlined,
              ),
              title: Text(L10n.of(context).sourceCode),
              onTap: () => launch(AppConfig.sourceCodeUrl),
            ),
            Divider(thickness: 1),
            ListTile(
              leading: Icon(
                Icons.bug_report_outlined,
              ),
              title: Text('Log console'),
              onTap: () => AdaptivePageLayout.of(context).pushNamed('/logs'),
            ),
          ],
        ),
      ),
    );
  }
}
