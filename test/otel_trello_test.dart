// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_trello/otel_trello.dart';
import 'package:test/test.dart';

void main() {
  group('otel_trello', () {
    test('suppression toggles in zone', () async {
      expect(trelloInstrumentationSuppressed(), isFalse);
      await runWithoutTrelloInstrumentationAsync(() async {
        expect(trelloInstrumentationSuppressed(), isTrue);
      });
      expect(trelloInstrumentationSuppressed(), isFalse);
    });

    test('TrelloResult fields default null', () {
      const r = TrelloResult();
      expect(r.statusCode, isNull);
    });
  });
}
