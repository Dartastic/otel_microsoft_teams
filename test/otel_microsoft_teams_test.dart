// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

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
