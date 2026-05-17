// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_trello_suppression.dart';

class TrelloResult {
  const TrelloResult({
    this.workspaceId,
    this.boardId,
    this.boardName,
    this.listId,
    this.cardId,
    this.cardName,
    this.memberId,
    this.action,
    this.labels,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? workspaceId;
  final String? boardId;
  final String? boardName;
  final String? listId;
  final String? cardId;
  final String? cardName;
  final String? memberId;
  final String? action;
  final String? labels;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class TrelloCallResult<T> {
  const TrelloCallResult({required this.value, this.result});
  final T value;
  final TrelloResult? result;
}

Future<T> tracedTrello<T>({
  required String operation,
  required Future<TrelloCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (trelloInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_trello');
  final span = t.startSpan('trello $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'trello');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.workspaceId != null) {
        span.setStringAttribute('trello.workspace.id', res.workspaceId!);
      }
      if (res.boardId != null) {
        span.setStringAttribute('trello.board.id', res.boardId!);
      }
      if (res.boardName != null) {
        span.setStringAttribute('trello.board.name', res.boardName!);
      }
      if (res.listId != null) {
        span.setStringAttribute('trello.list.id', res.listId!);
      }
      if (res.cardId != null) {
        span.setStringAttribute('trello.card.id', res.cardId!);
      }
      if (res.cardName != null) {
        span.setStringAttribute('trello.card.name', res.cardName!);
      }
      if (res.memberId != null) {
        span.setStringAttribute('user.id', res.memberId!);
      }
      if (res.action != null) {
        span.setStringAttribute('trello.action', res.action!);
      }
      if (res.labels != null) {
        span.setStringAttribute('trello.labels', res.labels!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('trello.error.code', res.errorCode!);
      }
      final fail =
          res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
          ErrorResource.errorType.key,
          res.errorCode ?? 'trello.error',
        );
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
