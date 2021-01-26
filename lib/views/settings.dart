import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/adaptive_page_layout.dart';
import '../components/matrix.dart';
import '../config/app_config.dart';
import '../utils/app_route.dart';
import 'settings/settings_account.dart';
import 'settings/settings_chat.dart';
import 'settings/settings_devices.dart';
import 'settings/settings_emotes.dart';
import 'settings/settings_encryption.dart';
import 'settings/settings_homeserver.dart';
import 'settings/settings_notifications.dart';
import 'settings/settings_themes.dart';

enum SettingsViews {
  account,
  homeserver,
  themes,
  chat,
  emotes,
  encryption,
  devices,
  notifications,
}

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.FIRST,
      firstScaffold: Settings(
        isInFocus: true,
      ),
      secondScaffold: Scaffold(
        body: Center(
          child: Image.asset('assets/logo.png', width: 100, height: 100),
        ),
      ),
    );
  }
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

  void _handleTap(Widget child) {
    widget.isInFocus
        ? Navigator.of(context).push(
            AppRoute.defaultRoute(
              context,
              child,
            ),
          )
        : Navigator.of(context).pushReplacement(
            AppRoute.defaultRoute(
              context,
              child,
            ),
          );
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
              onTap: () => _handleTap(AccountSettingsView()),
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
              onTap: () => _handleTap(HomeserverSettingsView()),
            ),
            ListTile(
              leading: Icon(
                Icons.color_lens_outlined,
              ),
              title: Text(L10n.of(context).changeTheme),
              selected:
                  widget.currentSetting == SettingsViews.themes ? true : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              onTap: () => _handleTap(ThemesSettingsView()),
            ),
            ListTile(
              leading: Icon(
                Icons.chat_outlined,
              ),
              title: Text(L10n.of(context).chat),
              selected:
                  widget.currentSetting == SettingsViews.chat ? true : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              onTap: () => _handleTap(ChatSettingsView()),
            ),
            ListTile(
              leading: Icon(
                Icons.insert_emoticon_outlined,
              ),
              title: Text(L10n.of(context).emoteSettings),
              selected:
                  widget.currentSetting == SettingsViews.emotes ? true : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              onTap: () => _handleTap(EmotesSettingsView()),
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
              onTap: () => _handleTap(EncryptionSettingsView()),
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
              onTap: () => _handleTap(NotificationsSettingsView()),
            ),
            ListTile(
              leading: Icon(
                Icons.devices_other_outlined,
              ),
              title: Text(L10n.of(context).devices),
              selected:
                  widget.currentSetting == SettingsViews.devices ? true : false,
              selectedTileColor: Theme.of(context).primaryColor.withAlpha(30),
              onTap: () => _handleTap(DevicesSettingsView()),
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
          ],
        ),
      ),
    );
  }
}
