// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

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
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'ms_teams')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.tenantId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('microsoft.tenant.id', res.tenantId!)]));
      }
      if (res.teamId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('microsoft.teams.team.id', res.teamId!)]));
      }
      if (res.channelId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('microsoft.teams.channel.id', res.channelId!)
        ]));
      }
      if (res.chatId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('microsoft.teams.chat.id', res.chatId!)]));
      }
      if (res.messageId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('microsoft.teams.message.id', res.messageId!)
        ]));
      }
      if (res.userId != null) {
        span.addAttributes(
            OTel.attributes([OTel.attributeString('user.id', res.userId!)]));
      }
      if (res.meetingId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('microsoft.teams.meeting.id', res.meetingId!)
        ]));
      }
      if (res.appId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('microsoft.teams.app.id', res.appId!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('teams.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
            ErrorResource.errorType.key,
            res.errorCode ?? 'teams.error',
          )
        ]));
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
