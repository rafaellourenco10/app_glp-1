import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 78.5 -> "78,5"; 130.0 -> "130".
String fmtNum(num v) => NumberFormat('#,##0.#', 'pt_BR').format(v);

/// Aceita "78,5" ou "78.5".
double? parseNum(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

String fmtTime(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// "20:00:00" (Postgres time) -> TimeOfDay.
TimeOfDay parseTime(String s) {
  final p = s.split(':');
  return TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
}

/// ISO weekday (1=seg..7=dom) -> "Domingo".
String weekdayName(int isoWeekday) {
  final s = DateFormat('EEEE', 'pt_BR').format(DateTime(2024, 1, isoWeekday)); // 01/01/2024 = segunda
  return s[0].toUpperCase() + s.substring(1);
}

/// "Domingo, 18/05"
String fmtDayDate(DateTime d) => '${weekdayName(d.weekday)}, ${DateFormat('dd/MM').format(d)}';

String fmtDateTime(DateTime d) => DateFormat('dd/MM, HH:mm').format(d);

DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// "Domingo, 18/Mai"
String fmtDayMonth(DateTime d) =>
    '${weekdayName(d.weekday)}, ${DateFormat('dd').format(d)}/${_cap(DateFormat('MMM', 'pt_BR').format(d).replaceAll('.', ''))}';

/// "Hoje, 14:20" · "Ontem, 19:15" · "Terça, 10:00" (última semana) · "12/05, 10:00".
String fmtRelative(DateTime d, {required String today, required String yesterday, DateTime? now}) {
  final days = dayOnly(now ?? DateTime.now()).difference(dayOnly(d)).inDays;
  final hm = DateFormat('HH:mm').format(d);
  if (days == 0) return '$today, $hm';
  if (days == 1) return '$yesterday, $hm';
  if (days < 7) return '${weekdayName(d.weekday).split('-').first}, $hm';
  return '${DateFormat('dd/MM').format(d)}, $hm';
}
