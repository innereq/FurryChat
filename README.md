# FurryChat

An experimental fork of FluffyChat.

# Changes from FluffyChat
 * Double check of .well-known
 * Get Jitsi from .well-known
 * Removed Sentry

# Features
 * Single and group chats
 * Send images and files
 * Voice messages
 * Offline chat history
 * Push Notifications
 * Account settings
 * Display user avatars
 * Themes, chat wallpapers and dark mode
 * Device management
 * Edit chat settings and permissions
 * Kick, ban and unban users
 * Display and edit chat topics
 * Change chat & user avatars
 * Archived chats
 * Discover public chats on the user's homeserver
 * Registration
 * Disable account
 * Change password
 * End-To-End-Encryption

## How to build

1. [Install flutter](https://flutter.dev)

2. Clone the repo:
```
git clone --recurse-submodules https://gitlab.com/ChristianPauly/fluffychat-flutter
cd fluffychat-flutter
```

### Android / iOS

3. For Android install CMake from the SDK Manager

4. Install ninja:
```
sudo apt install ninja-build
```

5. Outcomment the Google Services plugin at the end of the file `android/app/build.gradle`:
```
// apply plugin: "com.google.gms.google-services"
```

6. `flutter run`

### Web

3. `flutter channel beta && flutter upgrade`

4. `flutter config --enable-web`

5. `flutter run`

### Docker

Don't even ask.

`docker run -ti --privileged -v /dev/bus/usb:/dev/bus/usb -v ${PWD}:/build -v /home/inex/.pub-cache:/home/inex/.pub-cache -v /home/inex/flutter:/home/inex/flutter -d flutter-fluffy:1.0`

## How to add translations for your language

You can use Weblate to translate the app to your language:

https://hosted.weblate.org/projects/fluffychat/



1. Replace the non-translated string in the codebase:
```
Text("Hello world"),
```
with a method call:
```
Text(L10n.of(context).helloWorld),
```

and add the following import if missing:

```
import 'package:flutter_gen/gen_l10n/l10n.dart';
```

2. Add the string to `/lib/l10n/l10n_en.arb`:

(The following example need to be sorounded by the usual json `{}` and after the `@@locale` key)

Example A:
```
"helloWorld": "Hello World!",
"@helloWorld": {
  "description": "The conventional newborn programmer greeting"
}
```

Example B:
```
"hello": "Hello {userName}",
"@hello": {
  "description": "A message with a single parameter",
  "placeholders": {
    "userName": {
      "type": “String”,
      “example”: “Bob”
    }
  }
}
```

3. For testing just run a regular build without extras

# Special thanks to

* <a href="https://github.com/fabiyamada">Fabiyamada</a> is a graphics designer from Brasil and has made the fluffychat logo and the banner. Big thanks for her great designs.

* <a href="https://github.com/advocatux">Advocatux</a> has made the Spanish translation with great love and care. He always stands by my side and supports my work with great commitment.

* Thanks to MTRNord and Sorunome for developing.

* Thanks to Mark for all his support and the chat background.

* Also thanks to all translators and testers! With your help, fluffychat is now available in more than 12 languages.
