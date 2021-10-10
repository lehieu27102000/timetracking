import 'package:trackingtime/app/sign_in/valitdators.dart';

enum EmailSignFormType{signIn, register}

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignFormType.signIn,
    this.isLoading  = false,
    this.submitted = false
  });
  final String email;
  final String password;
  final EmailSignFormType formType;
  final bool isLoading;
  final bool submitted;
  EmailSignInModel CopyWith({
    String? email,
    String? password,
    EmailSignFormType? formType,
    bool? isLoading,
    bool? submitted
  }) {
    return  EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
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
