import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';

/// Lembrete semanal da aplicação. O agendamento fica no SO (AlarmManager / UNUserNotificationCenter),
/// então sobrevive a fechar o app; no Android o boot receiver reagenda após reiniciar o aparelho.
class Notifications {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static const _doseId = 1;

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation((await FlutterTimezone.getLocalTimezone()).identifier));
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  /// [first] = próxima ocorrência (hora local); repete no mesmo dia da semana e horário.
  /// [askPermission] só em ação do usuário, para não abrir diálogos a cada abertura do app.
  static Future<void> scheduleWeeklyDose({
    required DateTime first,
    required String medication,
    required String dose,
    bool askPermission = false,
  }) async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (askPermission) {
      await android?.requestNotificationsPermission();
      if (await android?.canScheduleExactNotifications() == false) await android?.requestExactAlarmsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
    final exact = await android?.canScheduleExactNotifications() ?? true;
    final l = lookupAppLocalizations(const Locale('pt'));
    await _plugin.cancel(id: _doseId);
    await _plugin.zonedSchedule(
      id: _doseId,
      scheduledDate: tz.TZDateTime.from(first, tz.local),
      title: l.notifTitle,
      body: l.notifBody(medication, dose),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails('dose', l.notifChannel, importance: Importance.high, priority: Priority.high),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: exact ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
    debugPrint('Lembrete de dose agendado para $first');
  }

  static Future<void> cancelDose() => _plugin.cancel(id: _doseId);
}
