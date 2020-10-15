import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../components/adaptive_page_layout.dart';
import '../../components/matrix.dart';
import '../settings.dart';

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
  String _getActionDescription(String action) {
    switch (action) {
      case 'reply':
        return L10n.of(context).reply;
      case 'forward':
        return L10n.of(context).forward;
      case 'edit':
        return L10n.of(context).edit;
      default:
        return L10n.of(context).none;
    }
  }

  void _changeSwipeAction(bool isToEnd, String action) async {
    if (isToEnd) {
      Matrix.of(context).swipeToEndAction = action;
      await Matrix.of(context)
          .store
          .setItem('chat.fluffy.swipeToEndAction', action);
      setState(() => null);
    } else {
      Matrix.of(context).swipeToStartAction = action;
      await Matrix.of(context)
          .store
          .setItem('chat.fluffy.swipeToStartAction', action);
      setState(() => null);
    }
  }

  Widget _swipeActionChooser(BuildContext context, bool isToEnd) {
    return ListView(
      children: [
        ListTile(
          title: Text(L10n.of(context).none),
          leading: Icon(Icons.clear_outlined),
          onTap: () {
            _changeSwipeAction(isToEnd, null);
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          title: Text(L10n.of(context).reply),
          leading: Icon(Icons.reply_outlined),
          onTap: () {
            _changeSwipeAction(isToEnd, 'reply');
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          title: Text(L10n.of(context).forward),
          leading: Icon(Icons.forward_outlined),
          onTap: () {
            _changeSwipeAction(isToEnd, 'forward');
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          title: Text(L10n.of(context).edit),
          leading: Icon(Icons.edit_outlined),
          onTap: () {
            _changeSwipeAction(isToEnd, 'edit');
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

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
          Divider(thickness: 1),
          ListTile(
            title: Text(L10n.of(context).swipeToEndAction),
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) =>
                  _swipeActionChooser(context, true),
            ),
            subtitle: Text(
                _getActionDescription(Matrix.of(context).swipeToEndAction)),
          ),
          ListTile(
            title: Text(L10n.of(context).swipeToStartAction),
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) =>
                  _swipeActionChooser(context, false),
            ),
            subtitle: Text(
                _getActionDescription(Matrix.of(context).swipeToStartAction)),
          ),
        ],
      ),
    );
  }
}
