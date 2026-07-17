// Tests for the ApiResponse helper class in api_service.dart.
// These test the response-wrapping logic directly — they don't hit a
// real network, since api_service.dart already handles network failures
// internally and returns ApiResponse.fail() rather than throwing.

import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_app/services/api_service.dart';

void main() {
  group('ApiResponse.ok', () {
    test('Marks response as successful and not from cache', () {
      final res = ApiResponse.ok({'name': 'Test'});
      expect(res.success, true);
      expect(res.fromCache, false);
      expect(res.error, isNull);
    });

    test('Carries the data through unchanged', () {
      final data = {'title': 'My Project', 'category': 'Flutter'};
      final res = ApiResponse.ok(data);
      expect(res.data, data);
    });
  });

  group('ApiResponse.cached', () {
    test('Marks response as successful but from cache', () {
      final res = ApiResponse.cached({'name': 'Cached Test'});
      expect(res.success, true);
      expect(res.fromCache, true);
    });
  });

  group('ApiResponse.fail', () {
    test('Marks response as unsuccessful with an error message', () {
      final res = ApiResponse.fail('Cannot reach server.');
      expect(res.success, false);
      expect(res.error, 'Cannot reach server.');
      expect(res.data, isNull);
    });
  });

  group('ApiResponse.isEmpty', () {
    test('Returns true when data is null', () {
      final res = ApiResponse.fail('some error');
      expect(res.isEmpty, true);
    });

    test('Returns true for an empty list', () {
      final res = ApiResponse.ok(<dynamic>[]);
      expect(res.isEmpty, true);
    });

    test('Returns false for a non-empty list', () {
      final res = ApiResponse.ok([1, 2, 3]);
      expect(res.isEmpty, false);
    });

    test('Returns true for an empty map', () {
      final res = ApiResponse.ok(<String, dynamic>{});
      expect(res.isEmpty, true);
    });

    test('Returns false for a non-empty map', () {
      final res = ApiResponse.ok({'name': 'Test'});
      expect(res.isEmpty, false);
    });
  });
}
