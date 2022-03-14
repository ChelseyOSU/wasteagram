import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(App());
    await SentryFlutter.init(
    (options) {
      options.dsn = 'https://7503377009ab4c9fbf8d92a0cfd34768@o1166523.ingest.sentry.io/6256989';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(App()),
  );
}

// try {
//   aMethodThatMightFail();
// } catch (exception, stackTrace) {
//   await Sentry.captureException(
//     exception,
//     stackTrace: stackTrace,
//   );
// }