# otel_microsoft_teams

Dartastic OpenTelemetry bridge for Microsoft Teams (chat + meetings + apps).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_microsoft_teams/otel_microsoft_teams.dart';

await tracedMicrosoftTeams<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return MicrosoftTeamsCallResult(value: r, result: MicrosoftTeamsResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutMicrosoftTeamsInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
