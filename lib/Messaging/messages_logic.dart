import 'dart:convert';
import 'package:competitivecodingarena/Auth_Profile_Logic/login_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  static Future<String> getAccessToken() async {
    final serviceAccountJSON = {
      "type": "service_account",
      "project_id": "leetcode-94c79",
      "private_key_id": "6d3334bab740ce393b0e4a09d6b4171319ce9e2b",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCIroCoDneILyET\nAlucyXYCK6lLpVBP2/zlRH/Mfs37agKB8cHYo5KO9gAQpEjL7jLcKj7PAmxkDRW0\n/+vF0TsEUveej7CDMplgzT4STIXGbK5Dj81GhBnTESKaIdM3d/z5VldLFvbqoEkb\nIof3N28tYJjQnwTBTQ2KlMAP39oRrmT7cLIQoBW1DGX9B9vwJaRzzd02y0KwP8YD\nbqNcJ7pfmWGnNcLR8hibYEc4YgirWOJ3wXBhbN6/5adBub2MzbvcUUOghcrM4fVG\nV8nf4dS1WfSm3ABBrcXlIrMdrlN9E8lFOcufrQFl9ByLOgw+67of0+yX4ppsLB6b\nV5QhoVibAgMBAAECggEANxIEQXIuxB6lF1kkW1wqoX5BBHsTjFGpKCD80wKmcK2K\nXBvxzB0/0D0a0pm2wP/02xNkYhjqXjeNbvOMZhRC0J+zKF5hssLg3IllgI73eXbR\nkeQvQ8G2+/1T8UE+roM4WKfqnRUgIHG7cuTrXnal42UfvTLNAitPEO6VIfBCF0wT\no+lsUQJQ+XbgygY2jbms6wst92jw9ADyTqjrHMN4oxNj8JlfVsgKzCBJkktZOLkW\n5Vv5PbOBsjSHxhN6Ia1Ut1Q+aOpJgDalnkuYHohL4hk5mojxh6xNPGXSAQQhdNdN\negWAQho1LZpXs+hMw8AU8GQCd/BpKn+wi7oC0PKtAQKBgQC708LnFzWFREFhKfuK\nyd7uYsjiX6E4zLyuKGwBFRtX8kbU8b9mm2Ggcl0nqULBel96Ch5UTF2A59GBZZo5\n83QrNzcBkZhhWF9TzndW7f6DuxLqdmFkT3kAWi94jHbyq9AZgZIkTfmNdVC9enXW\npiJXDKCrbfkPzf1rBWxtaK4HmwKBgQC6Snpw/IWvnejwmgg3HAbESqyjrVsLB0Xb\nW6VCWptsu3kiqSWQJwAP9Q5fUmxBfq0fPxaOYk/UTLxf9ytpn/AdNKL+SMK9jJJb\nigYNO+Kun0eXKAFOKZNcfv2oGjWiJGzX6atEYFc3nq6EgAfPgi316P5mJ8Gd3P4Y\nbuzHk52DAQKBgGSKiTT8VnjcvYaOW4jCYKQImvGaMQnfhkxPdOjrbHSaStIoCcWZ\n/RtOvJDDaOl6YOtJyUxkiFS9QodaZMEKka+kYbxkPEY3cOfCiF0vDmNjW0/ISH/S\njrnijLCht/ZUhBNzKVBnsOLI3oxepf9ddNpV9xdsybptEG8eOxkhxK5rAoGAJ1xL\nKIpCWMu9hvCUocg7Kcg5V8/t95OOz/06Gp34Tu4BdzBT7nQ/ECAP7FYG54OzYnG6\n+1SMV2frOT+JHaUcX59afO20r8X+unacNrmbeJfQ0YAzXmdsalOulpELGfomQSxu\n8mCErQzLBNXkUJTJzzZuYfkucINb8J+nSbfHxQECgYEAlXciTado5SMJueMxo5ho\niHiERVDTP8SI7hcPxRcwlErGFnBtfz8TJjDQP55R8XfPX1/7f0KDD7UGDZjVIpIa\nBhjsdiCc+Z87m7kPP9KbLSFgIJIb1/fkOGimhCzZiw4g4vFn8Gq67rIQj5krEpHb\nEi/6yYjT7JUrL+KhrXBBJp8=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-gb568@leetcode-94c79.iam.gserviceaccount.com",
      "client_id": "113247645718234159585",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-gb568%40leetcode-94c79.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
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
