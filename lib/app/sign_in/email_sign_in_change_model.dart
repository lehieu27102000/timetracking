import 'package:flutter/cupertino.dart';
import 'package:trackingtime/app/sign_in/valitdators.dart';
import 'package:trackingtime/services/auth.dart';

import 'email_sign_in_model.dart';


class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignFormType.signIn,
    this.isLoading  = false,
    this.submitted = false,
    required this.auth
  });
  final AuthBase auth;
  String email;
  String password;
  EmailSignFormType formType;
  bool isLoading;
  bool submitted;
  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignFormType.signIn) {
        await auth.signInWithAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (error) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }
  void updateWith({
    String? email,
    String? password,
    EmailSignFormType? formType,
    bool? isLoading,
    bool? submitted
  }) {
      this.email = email ?? this.email;
      this.password = password ?? this.password;
      this.formType = formType ?? this.formType;
      this.isLoading = isLoading ?? this.isLoading;
      this.submitted = submitted ?? this.submitted;
      notifyListeners();
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == EmailSignFormType.signIn ? EmailSignFormType.register : EmailSignFormType.signIn;
    updateWith(
        email: '',
        password: '',
        formType: formType,
        isLoading: false,
        submitted: false
    );
  }

  String get prinaryButtonText {
    return formType == EmailSignFormType.signIn ? 'Sign in' : 'Create an account';
  }
  String get subText  {
    return formType == EmailSignFormType.signIn ? 'Need an account ? Register'
        : 'Have an account ? Sign in';
  }

  String get validationEmail {
    final String textError;
    if (submitted && !emailValidator.isValid(email)) {
      textError = 'Bạn chưa nhập email';
    } else {
      textError = '';
    }
    return textError;
  }

  String get validationPassword {
    final String textError;
    if (submitted && !passwordValidator.isValid(password)) {
      textError = 'Bạn chưa nhập password';
    } else if (submitted && !passwordValidator.minInput(password)) {
      textError = 'Mật khẩu của bạn phải ít nhất 4 ký tự';
    } else {
      textError = '';
    }
    return textError;
  }
}
