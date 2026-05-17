// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_microsoft_teams/otel_microsoft_teams.dart';
import 'package:test/test.dart';

void main() {
  group('otel_microsoft_teams', () {
    test('suppression toggles in zone', () async {
      expect(microsoftTeamsInstrumentationSuppressed(), isFalse);
      await runWithoutMicrosoftTeamsInstrumentationAsync(() async {
        expect(microsoftTeamsInstrumentationSuppressed(), isTrue);
      });
      expect(microsoftTeamsInstrumentationSuppressed(), isFalse);
    });

    test('MicrosoftTeamsResult fields default null', () {
      const r = MicrosoftTeamsResult();
      expect(r.statusCode, isNull);
    });
  });
}
