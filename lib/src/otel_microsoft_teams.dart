// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_microsoft_teams_suppression.dart';

class MicrosoftTeamsResult {
  const MicrosoftTeamsResult({
    this.tenantId,
    this.teamId,
    this.channelId,
    this.chatId,
    this.messageId,
    this.userId,
    this.meetingId,
    this.appId,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? tenantId;
  final String? teamId;
  final String? channelId;
  final String? chatId;
  final String? messageId;
  final String? userId;
  final String? meetingId;
  final String? appId;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class MicrosoftTeamsCallResult<T> {
  const MicrosoftTeamsCallResult({required this.value, this.result});
  final T value;
  final MicrosoftTeamsResult? result;
}

Future<T> tracedMicrosoftTeams<T>({
  required String operation,
  required Future<MicrosoftTeamsCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (microsoftTeamsInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_microsoft_teams');
  final span = t.startSpan('teams $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'ms_teams');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.tenantId != null) {
        span.setStringAttribute('microsoft.tenant.id', res.tenantId!);
      }
      if (res.teamId != null) {
        span.setStringAttribute('microsoft.teams.team.id', res.teamId!);
      }
      if (res.channelId != null) {
        span.setStringAttribute('microsoft.teams.channel.id', res.channelId!);
      }
      if (res.chatId != null) {
        span.setStringAttribute('microsoft.teams.chat.id', res.chatId!);
      }
      if (res.messageId != null) {
        span.setStringAttribute('microsoft.teams.message.id', res.messageId!);
      }
      if (res.userId != null) {
        span.setStringAttribute('user.id', res.userId!);
      }
      if (res.meetingId != null) {
        span.setStringAttribute('microsoft.teams.meeting.id', res.meetingId!);
      }
      if (res.appId != null) {
        span.setStringAttribute('microsoft.teams.app.id', res.appId!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('teams.error.code', res.errorCode!);
      }
      final fail =
          res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
          ErrorResource.errorType.key,
          res.errorCode ?? 'teams.error',
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
