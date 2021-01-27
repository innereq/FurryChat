import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

import '../components/matrix.dart';
import '../utils/app_route.dart';
import 'login.dart';
import 'sign_up.dart';

class HomeserverPicker extends StatefulWidget {
  @override
  _HomeserverPickerState createState() => _HomeserverPickerState();
}

class _HomeserverPickerState extends State<HomeserverPicker> {
  void _checkHomeserverAction(String homeserver, BuildContext context) async {
    if (!_isMXID && !homeserver.startsWith('https://')) {
      homeserver = 'https://$homeserver';
    }
    WellKnownInformations wellknown;
    if (_isMXID) {
      if (!homeserver.startsWith('@')) {
        homeserver = '@$homeserver';
      }
      wellknown = (await showFutureLoadingDialog(
              context: context,
              future: () => Matrix.of(context)
                  .client
                  .getWellKnownInformationsByUserId(homeserver)))
          .result;
      final success = (await showFutureLoadingDialog(
              context: context,
              future: () => checkHomeserver(
                  wellknown.mHomeserver != null
                      ? 'https://${Uri.parse(wellknown.mHomeserver.baseUrl).host}'
                      : homeserver,
                  Matrix.of(context).client)))
          .result;
      if (success != false) {
        await Navigator.of(context).push(AppRoute(Login(
          username: homeserver,
          wellknown: wellknown,
        )));
      }
    } else {
      homeserver = homeserver.trim();
      if (homeserver.endsWith('/')) {
        homeserver = homeserver.substring(0, homeserver.length - 1);
      }
      wellknown = (await showFutureLoadingDialog(
              context: context,
              future: () => Matrix.of(context)
                  .client
                  .getWellKnownInformationsByUserId(homeserver)))
          .result;

      final success = (await showFutureLoadingDialog(
              context: context,
              future: () => checkHomeserver(
                  wellknown.mHomeserver != null
                      ? 'https://${Uri.parse(wellknown.mHomeserver.baseUrl).host}'
                      : homeserver,
                  Matrix.of(context).client)))
          .result;
      if (success != false) {
        await Navigator.of(context).push(AppRoute(SignUp(
          wellknown: wellknown,
        )));
      }
    }
  }

  Future<bool> checkHomeserver(dynamic homeserver, Client client) async {
    await client.checkHomeserver(homeserver);
    return true;
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
