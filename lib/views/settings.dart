import 'package:furrychat/config/app_config.dart';
import 'package:furrychat/views/settings/settings_account.dart';
import 'package:furrychat/views/settings/settings_chat.dart';
import 'package:furrychat/views/settings/settings_devices.dart';
import 'package:furrychat/views/settings/settings_encryption.dart';
import 'package:furrychat/views/settings/settings_homeserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:furrychat/views/settings/settings_themes.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:furrychat/components/adaptive_page_layout.dart';
import 'package:furrychat/components/matrix.dart';
import 'package:furrychat/utils/app_route.dart';
import 'package:furrychat/views/settings/settings_emotes.dart';

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

  const Settings({this.isInFocus = false, Key key}) : super(key: key);

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
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).appBarTheme.color,
            title: Text(L10n.of(context).settings),
          ),
        ],
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.person_outlined,
                  )),
              title: Text(profile?.displayname ?? L10n.of(context).account),
              subtitle: Text(client.userID),
              onTap: () => _handleTap(AccountSettingsView()),
            ),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.dns_outlined,
                  )),
              title: Text(L10n.of(context).homeserver),
              subtitle: Text(client.homeserver.host),
              onTap: () => _handleTap(HomeserverSettingsView()),
            ),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.color_lens_outlined,
                  )),
              title: Text(L10n.of(context).changeTheme),
              onTap: () => _handleTap(ThemesSettingsView()),
            ),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.chat_outlined,
                  )),
              title: Text(L10n.of(context).chat),
              onTap: () => _handleTap(ChatSettingsView()),
            ),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.insert_emoticon_outlined,
                  )),
              title: Text(L10n.of(context).emoteSettings),
              onTap: () => _handleTap(EmotesSettingsView()),
            ),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.lock_outline,
                  )),
              title: Text(L10n.of(context).encryption),
              onTap: () => _handleTap(EncryptionSettingsView()),
            ),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.devices_other_outlined,
                  )),
              title: Text(L10n.of(context).devices),
              onTap: () => _handleTap(DevicesSettingsView()),
            ),
            Divider(thickness: 1),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.help_outline_outlined,
                  )),
              title: Text(L10n.of(context).help),
              onTap: () => launch(AppConfig.supportUrl),
            ),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.privacy_tip_outlined,
                  )),
              title: Text(L10n.of(context).privacy),
              onTap: () => launch(AppConfig.privacyUrl),
            ),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.link_outlined,
                  )),
              title: Text(L10n.of(context).license),
              onTap: () => showLicensePage(
                context: context,
                applicationIcon:
                    Image.asset('assets/logo.png', width: 100, height: 100),
                applicationName: AppConfig.applicationName,
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.grey,
                  child: Icon(
                    Icons.code_outlined,
                  )),
              title: Text(L10n.of(context).sourceCode),
              onTap: () => launch(AppConfig.sourceCodeUrl),
            ),
          ],
        ),
      ),
    );
  }
}
