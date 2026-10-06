import 'package:companheiro_glp1/features/doses/doses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const t2000 = TimeOfDay(hour: 20, minute: 0);
  // 2026-10-04 é domingo (ISO 7).
  test('mesmo dia, antes do horário -> hoje', () {
    expect(nextOccurrence(7, t2000, DateTime(2026, 10, 4, 19, 58)), DateTime(2026, 10, 4, 20));
  });
  test('mesmo dia, depois do horário -> semana seguinte', () {
    expect(nextOccurrence(7, t2000, DateTime(2026, 10, 4, 20, 0)), DateTime(2026, 10, 11, 20));
  });
  test('outro dia da semana, virando o mês', () {
    expect(nextOccurrence(1, t2000, DateTime(2026, 10, 31, 9)), DateTime(2026, 11, 2, 20)); // sáb -> seg
  });
}
