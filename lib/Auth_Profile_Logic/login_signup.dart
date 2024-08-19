import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leetcodeclone/Core_Project/Problemset/containers/homescreen.dart';
import 'package:leetcodeclone/Snackbars&Pbars/snackbars.dart';
import 'package:leetcodeclone/Auth_Profile_Logic/VerifyMail/verifyMail.dart';
import 'package:leetcodeclone/Welcome/welcome.dart';

void loginLogic(BuildContext context, String email, String password) async {
  bool isLoginSuccessful = false;
  showCircularbar(context);
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    isLoginSuccessful = true;
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.code);
  }
  Navigator.of(context).pop();
  if (isLoginSuccessful) {
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => LeetCodeProblemsetHomescreen(
                size: MediaQuery.of(context).size)),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const VerifyMail()));
    }
  }
}

void signUpLogic(
  BuildContext context,
  String email,
  String password,
  String name,
) async {
  showCircularbar(context);
  bool isSignupSuccessful = false;
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    await FirebaseAuth.instance.currentUser!.updatePassword(password);
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    isSignupSuccessful = true;
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.code);
  }
  Navigator.of(context).pop();
  if (isSignupSuccessful) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const VerifyMail()));
  }
}

void logoutLogic(BuildContext context) async {
  bool isLoginOutSuccessful = false;
  showCircularbar(context);
  try {
    await FirebaseAuth.instance.signOut();

    isLoginOutSuccessful = true;
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.code);
  }
  Navigator.of(context).pop();
  if (isLoginOutSuccessful) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
  }
}

Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists || !docSnapshot.data()!.containsKey('roadmap')) {
      await userDoc.set({"roadmap": null}, SetOptions(merge: true));
    }

    return userCredential;
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.message!);
    return null;
  }
}

Future<UserCredential?> gitHubSignIn(BuildContext context) async {
  String? clientId;
  String? clientSecret;

  try {
    clientId = dotenv.env["clientId"];
    clientSecret = dotenv.env["client_secret"];
    if (clientId == null || clientSecret == null) {
      throw Exception("One or more required environment variables are missing");
    }
    final githubAuthProvider = GithubAuthProvider();
    githubAuthProvider.addScope('read:user');
    githubAuthProvider.addScope('user:email');
    githubAuthProvider.setCustomParameters({
      'allow_signup': 'true',
    });
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(githubAuthProvider);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  } catch (error) {
    showSnackBar(context, error.toString());
  }
  return null;
}
