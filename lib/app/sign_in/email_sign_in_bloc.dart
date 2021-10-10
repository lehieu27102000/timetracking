import 'dart:async';
import 'package:trackingtime/app/sign_in/email_sign_in_model.dart';
import 'package:trackingtime/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignFormType? formType,
    bool? isLoading,
    bool? submitted
  }) {
    // print(email);
    _model = _model.CopyWith(
      email:email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted
    );
    _modelController.add(_model);
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = _model.formType == EmailSignFormType.signIn ? EmailSignFormType.register : EmailSignFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false
    );
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignFormType.signIn) {
        await auth.signInWithAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      }
    } catch (error) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }
}