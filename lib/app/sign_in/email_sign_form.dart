import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingtime/common_widgets/form_submit_button.dart';
import 'package:trackingtime/common_widgets/show_alert_dialog.dart';
import 'package:trackingtime/services/auth.dart';

import 'email_sign_in_bloc.dart';
import 'email_sign_in_model.dart';
// ignore: must_be_immutable
class EmailSignForm extends StatefulWidget {
  EmailSignForm({required this.bloc});
  EmailSignInBloc bloc;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
        create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignForm(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignFormState createState() => _EmailSignFormState();
}

class _EmailSignFormState extends State<EmailSignForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailForcusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String errorText = '';

  void dispose() {
    _emailForcusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Future<void> _submit() async{
    try {
      // await Future.delayed(Duration(seconds: 3));
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException  catch (error) {
      print(error.toString());
      if (error.code == 'invalid-email') {
        errorText = 'Email không đúng định dạng';
      } else if (error.code == 'user-not-found') {
        errorText = 'Mật khẩu hoặc email không đúng';
      } else if (error.code == 'unknown') {
        errorText = 'Bạn chưa nhập email hoặc password';
      } else if (error.code == 'wrong-password') {
        errorText = 'Sai mật khẩu';
      }
      showAlertDialog(
          context,
          title: 'Login thất bại',
          content: errorText,
          activeDefaultText: 'OK',
          cancelActiveText: null
      );
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }
  void _emailEditComplete(EmailSignInModel? model) {
    final newForcus = model!.emailValidator.isValid(model.email) ? _passwordFocusNode : _emailForcusNode;
    FocusScope.of(context).requestFocus(newForcus);
  }

  TextField _buildEmailTextField(EmailSignInModel? model) {
    String? showTextError = model!.validationEmail.isNotEmpty ? model.validationEmail : null;
    return TextField(
      controller: _emailController,
      onChanged: (email) => widget.bloc.updateEmail(email),
      focusNode: _emailForcusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@gmail.com',
          errorText: showTextError,
          enabled: model.isLoading  == false
      ),
      autocorrect: true,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditComplete(model),
    );
  }
  TextField _buidPasswordTextField(EmailSignInModel? model) {
    String? showErrorText = model!.validationPassword.isNotEmpty ? model.validationPassword : null;
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText,
        enabled: model.isLoading  == false
      ),
      onChanged: (password) => widget.bloc.updatePassword(password),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
    );
  }
  List<Widget> _buidChildren(EmailSignInModel? model) {
    final primaryText = model!.prinaryButtonText;
    final subText = model.subText;

    return [
      _buildEmailTextField(model),
      SizedBox(
        height: 8.0,
      ),
      _buidPasswordTextField(model),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
          text: primaryText,
          color: Colors.indigo,
          onPressed: () => _submit()
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(subText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel? model = snapshot.data;
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buidChildren(model),
          ),
        );
      },
    );
  }
}
