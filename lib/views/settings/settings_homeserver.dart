import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../components/adaptive_page_layout.dart';
import '../../components/matrix.dart';
import '../settings.dart';

class HomeserverSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: Settings(currentSetting: SettingsViews.homeserver),
      secondScaffold: HomeserverSettings(),
    );
  }
}

class HomeserverSettings extends StatefulWidget {
  @override
  _HomeserverSettingsState createState() => _HomeserverSettingsState();
}

class _HomeserverSettingsState extends State<HomeserverSettings> {
  @override
  Widget build(BuildContext context) {
    var client = Matrix.of(context).client;
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).homeserver)),
      body: ListView(
        children: [
          ListTile(
            title: Text(L10n.of(context).yourOwnUsername + ':'),
            subtitle: Text(client.userID),
          ),
          ListTile(
            title: Text('Homeserver:'),
            subtitle: Text(client.homeserver.toString()),
          ),
        ],
      ),
    );
  }
}
