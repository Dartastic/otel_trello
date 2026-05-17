# otel_trello

Dartastic OpenTelemetry bridge for Trello (kanban task mgmt).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_trello/otel_trello.dart';

await tracedTrello<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return TrelloCallResult(value: r, result: TrelloResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutTrelloInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
