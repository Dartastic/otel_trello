// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_trello/otel_trello.dart';

/// Traces Trello calls with OpenTelemetry.
///
/// `otel_trello` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Trello call in
/// [tracedTrello]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'trello-example');

  // Traces a Trello call.
  final trelloId = await tracedTrello<String>(
    operation: 'create',
    invoke: () async {
      // Make the Trello call here, then report what it returned.
      const id = 'trello_8f3a2c';
      return const TrelloCallResult(
          value: id,
          result: TrelloResult(
              workspaceId: 'workspace_8f3a2c',
              boardId: 'board_8f3a2c',
              boardName: 'example',
              listId: 'list_8f3a2c',
              cardId: 'card_8f3a2c',
              cardName: 'example',
              memberId: 'member_8f3a2c',
              action: 'example',
              labels: 'example',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedTrello create returned $trelloId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutTrelloInstrumentationAsync.
  await runWithoutTrelloInstrumentationAsync(
    () => tracedTrello<String>(
      operation: 'create',
      invoke: () async {
        const id = 'trello_8f3a2c';
        return const TrelloCallResult(
            value: id,
            result: TrelloResult(
                workspaceId: 'workspace_8f3a2c',
                boardId: 'board_8f3a2c',
                boardName: 'example',
                listId: 'list_8f3a2c',
                cardId: 'card_8f3a2c',
                cardName: 'example',
                memberId: 'member_8f3a2c',
                action: 'example',
                labels: 'example',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
