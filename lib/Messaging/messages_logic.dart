import 'dart:convert';
import 'package:competitivecodingarena/Auth_Profile_Logic/login_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  static Future<String> getAccessToken() async {
    final serviceAccountJSON = {};
    List<String> scopes = [
      'https://www.googleapis.com/auth/cloud-platform',
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/firebase',
    ];
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJSON), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJSON),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  static sendNotification(String token) async {
    final String serverKey = await getAccessToken();
    String endPointFirebaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/leetcode-94c79/messages:send";
    final Map<String, dynamic> message = {
      'message': {
        'token': token,
        'notification': {
          'title': "WELCOME!!!",
          'body': "START YOUR CODING JOURNEY",
        },
      }
    };
    final http.Response response = await http.post(
        Uri.parse(endPointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey'
        },
        body: jsonEncode(message));
    if (response.statusCode == 200) {
      print("SucessFul");
    } else {
      print("Failed");
    }
  }
}

Future<void> requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  try {
    NotificationSettings settings = await messaging
        .requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        )
        .timeout(const Duration(seconds: 5));

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await generateTokenForUser();
      print(token ?? "NOT GENERATED");
      if (token != null && FirebaseAuth.instance.currentUser != null) {
        await updatetoken(token, FirebaseAuth.instance.currentUser!);
        //    PushNotification.sendNotification(token); //To test if notifications work
      }
    }
    _configureMessageListeners();
  } catch (e) {
    print('Notification permission request failed: $e');
  }
}

void _configureMessageListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    compute(_handleForegroundMessage, message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleMessageNavigation(message);
  });
}

void _handleForegroundMessage(RemoteMessage message) {
  print('Received foreground message: ${message.notification?.title}');
}

void _handleMessageNavigation(RemoteMessage message) {
  print('Message opened app: ${message.notification?.title}');
}
