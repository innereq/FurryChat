import 'dart:math';

import 'package:famedlysdk/matrix_api/model/well_known_informations.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/login.dart';
import 'package:fluffychat/views/sign_up.dart';
import 'package:flutter/material.dart';

class HomeserverPicker extends StatefulWidget {
  @override
  _HomeserverPickerState createState() => _HomeserverPickerState();
}

class _HomeserverPickerState extends State<HomeserverPicker> {
  Future<void> _setHomeserverAction(BuildContext context) async {
    final homeserver = await SimpleDialogs(context).enterText(
        titleText: L10n.of(context).enterYourHomeserver,
        hintText: Matrix.defaultHomeserver,
        prefixText: 'https://');
    if (homeserver?.isEmpty ?? true) return;
    _checkHomeserverAction(homeserver, context);
  }

  void _checkHomeserverAction(String homeserver, BuildContext context) async {
    if (!_isMXID && !homeserver.startsWith('https://')) {
      homeserver = 'https://$homeserver';
    }
    WellKnownInformations wellknown;
    if (_isMXID) {
      if (!homeserver.startsWith('@')) {
        homeserver = '@$homeserver';
      }
      wellknown = await SimpleDialogs(context).tryRequestWithLoadingDialog(
          Matrix.of(context)
              .client
              .getWellKnownInformationsByUserId(homeserver));
      final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
          Matrix.of(context).client.checkServer(wellknown.mHomeserver != null
              ? 'https://${Uri.parse(wellknown.mHomeserver.baseUrl).host}'
              : homeserver));
      if (success != false) {
        await Navigator.of(context).push(AppRoute(Login(
          username: homeserver,
          wellknown: wellknown,
        )));
      }
    } else {
      wellknown = await SimpleDialogs(context).tryRequestWithLoadingDialog(
          Matrix.of(context)
              .client
              .getWellKnownInformationsByDomain(homeserver));

      final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
          Matrix.of(context).client.checkServer(wellknown.mHomeserver != null
              ? 'https://${Uri.parse(wellknown.mHomeserver.baseUrl).host}'
              : homeserver));
      if (success != false) {
        await Navigator.of(context).push(AppRoute(SignUp(
          wellknown: wellknown,
        )));
      }
    }
  }

  final textController = TextEditingController();
  bool _isMXID = false;

  void _checkInputType() {
    if (textController.text.contains(':')) {
      setState(() {
        _isMXID = true;
      });
    } else {
      setState(() {
        _isMXID = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(_checkInputType);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  max((MediaQuery.of(context).size.width - 600) / 2, 0)),
          child: Column(
            children: <Widget>[
              Hero(
                tag: 'loginBanner',
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 18.0),
                    child: Text(
                      L10n.of(context).fluffychat,
                      style: TextStyle(fontSize: 28.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  L10n.of(context).welcomeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: textController,
                  onSubmitted: (s) {
                    _checkHomeserverAction(s, context);
                  },
                  decoration: InputDecoration(
                    icon: (_isMXID
                        ? Icon(Icons.person_outline)
                        : Icon(Icons.business)),
                    labelText: L10n.of(context).homeserverOrMXID,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Spacer(),
              Hero(
                tag: 'loginButton',
                child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: RaisedButton(
                    elevation: 7,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      (_isMXID
                          ? L10n.of(context).login.toUpperCase()
                          : L10n.of(context).connect.toUpperCase()),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () =>
                        _checkHomeserverAction(textController.text, context),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
