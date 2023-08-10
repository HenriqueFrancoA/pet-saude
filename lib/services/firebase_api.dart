import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

Future<void> handleBackgroundMensagem(RemoteMessage? mensagem) async {
  print('Título: ${mensagem?.notification?.title}');
  print('Body: ${mensagem?.notification?.body}');
  print('Payload: ${mensagem?.data}');
}

Future<void> handleMensagem(RemoteMessage? mensagem) async {
  if (mensagem == null) return;
}

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel',
    importance: Importance.defaultImportance,
  );

  final localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const configs = InitializationSettings(
      android: android,
    );

    await localNotification.initialize(
      configs,
    );

    final plataforma = localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await plataforma?.createNotificationChannel(androidChannel);
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMensagem);
    FirebaseMessaging.onMessage.listen((mensagem) {
      final notification = mensagem.notification;

      if (notification == null) return;

      localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidChannel.id,
            androidChannel.name,
            channelDescription: androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(mensagem.toMap()),
      );
    });
  }

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();

    final fcmToken = await firebaseMessaging.getToken();

    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString('token', fcmToken!);
    });
    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> scheduleNotification(DateTime nextVacinaDate) async {
    // Defina a data da notificação, três dias antes da próxima vacina
    final notificationDate = nextVacinaDate.subtract(Duration(days: 3));

    // Verifique se a data da notificação é no futuro
    if (notificationDate.isAfter(DateTime.now())) {
      tz.initializeTimeZones();
      // Crie um objeto TZDateTime usando o fuso horário local do dispositivo
      final localNotificationTimeZone = tz.getLocation('America/Sao_Paulo');
      final tzNotificationDate =
          tz.TZDateTime.from(notificationDate, localNotificationTimeZone);

      final fcmToken = await firebaseMessaging.getToken();

      // Agende a notificação usando o token FCM como ID único
      await localNotification.zonedSchedule(
        fcmToken.hashCode, // Usando o hashCode do token como ID da notificação
        'Próxima vacina em 3 dias',
        'Não esqueça da próxima vacina em 3 dias!',
        tzNotificationDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            channelDescription: 'channel description',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
        ),
        payload: jsonEncode({'type': 'vacina_notification'}),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}
