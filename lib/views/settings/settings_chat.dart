import 'package:furrychat/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:furrychat/components/adaptive_page_layout.dart';
import 'package:furrychat/components/matrix.dart';

class ChatSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: Settings(currentSetting: SettingsViews.chat),
      secondScaffold: ChatSettings(),
    );
  }
}

class ChatSettings extends StatefulWidget {
  @override
  _ChatSettingsState createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).chat)),
      body: ListView(
        children: [
          ListTile(
            title: Text(L10n.of(context).renderRichContent),
            trailing: Switch(
              value: Matrix.of(context).renderHtml,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool newValue) async {
                Matrix.of(context).renderHtml = newValue;
                await Matrix.of(context)
                    .store
                    .setItem('chat.fluffy.renderHtml', newValue ? '1' : '0');
                setState(() => null);
              },
            ),
          ),
        ],
      ),
    );
  }
}
