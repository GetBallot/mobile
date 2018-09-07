Thank you for your interest!

First thing first, read [DESIGN.md](https://github.com/GetBallot/mobile/blob/master/DESIGN.md) to understand how the project is structured.

## Compiling

### Flutter
Set up [Flutter](https://flutter.io/).

If Android Studio complains that the Dart SDK is not installed, point it to
`~/development/flutter/bin/cache/dart-sdk` (`~/development/flutter` beingfire the directory where you installed Flutter).

If `flutter doctor` complains about Android licenses, run     

    flutter doctor --android-licenses

### Google Civic Information API
1. Acquire an API key for [Places API]( https://cloud.google.com/maps-platform/places).
2. Copy `lib/credentials.dart.template` to `lib/credentials.dart` and put Google API key in it.

### Firebase
1. In [Firebase console](https://console.firebase.google.com/), find the project you created for [Google Civic Information API
](https://developers.google.com/civic-information/docs/using_api).


**For Android:**
```
- Project Overview → Add App → Android.
- Put `com.getballot.guide.staging` as package name
- Download `google-services.json`. Move to `android/app`.
```

**For IOS:**
```
- Project Overview → Add App → IOS.
- Put `com.getballot.staging` as package name
- Download `GoogleServices-Info.plist`. Move to `ios/Runner`.
```

2. Authentication &rarr; Sign-in method &rarr; enable Google and Anonymous
3. Database  &rarr; Get Started

### Android Studio
After you fork and clone the project, Open (instead of import) in Android Studio.

On the toolbar, click on the down triangle next to `main.dart`. Select `Edit Configurations...`. Set Build flavor to `staging`.

### Xcode
After you fork and clone the project, Open Runner.xcworkspace.

Before compliing and running the app, go to:
File > Workplace Settings > Build System: Legacy Build System (It’s on New Build System by default)

This makes sure the legacy code is read properly.

Now run the app.

## Issues

Before writing any code, please comment on the corresponding [issue](https://github.com/GetBallot/mobile/issues) to clarify what needs to be done and how you plan to do it. Create an issue if needed.
