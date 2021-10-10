import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackingtime/services/auth.dart';


class SignInBloc {
  SignInBloc({required this.auth, required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  // final StreamController<bool> _isLoadingController = StreamController<bool>();
  // Stream<bool> get isLoadingStream => _isLoadingController.stream;
  // void dispose() {
  //   _isLoadingController.close();
  // }
  // void setIsLoading(bool isLoading) {
  //   return _isLoadingController.add(isLoading);
  // }
  Future<User?> _SignIn(Future<User?> Function() signMethod) async {
    try {
      isLoading.value = true;
      return await signMethod();
    } catch(error) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
  Future<User?> signInAnonymously() async => await _SignIn(() => auth.signInAnonymously());
  Future<User?> signInWithGoogle() async => await _SignIn(() => auth.signInWithGoogle());
  Future<User?> signInWithFacebook() async => await _SignIn(() => auth.signInWithFacebook());
}