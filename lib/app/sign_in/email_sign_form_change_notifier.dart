import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingtime/app/sign_in/email_sign_in_change_model.dart';
import 'package:trackingtime/common_widgets/form_submit_button.dart';
import 'package:trackingtime/common_widgets/show_alert_dialog.dart';
import 'package:trackingtime/services/auth.dart';

class EmailSignFormChangeNotifier extends StatefulWidget {
  EmailSignFormChangeNotifier({required this.model});
  EmailSignInChangeModel model;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
        create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignFormChangeNotifierState createState() => _EmailSignFormChangeNotifierState();
}

class _EmailSignFormChangeNotifierState extends State<EmailSignFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailForcusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInChangeModel get model => widget.model;
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
      await model.submit();
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
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }
  void _emailEditComplete() {
    final newForcus = model.emailValidator.isValid(model.email) ? _passwordFocusNode : _emailForcusNode;
    FocusScope.of(context).requestFocus(newForcus);
  }

  TextField _buildEmailTextField() {
    String? showTextError = model.validationEmail.isNotEmpty ? model.validationEmail : null;
    return TextField(
      controller: _emailController,
      onChanged: (email) => model.updateEmail(email),
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
      onEditingComplete: () => _emailEditComplete(),
    );
  }
  TextField _buidPasswordTextField() {
    String? showErrorText = model.validationPassword.isNotEmpty ? model.validationPassword : null;
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText,
        enabled: model.isLoading  == false
      ),
      onChanged: (password) => model.updatePassword(password),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
    );
  }
  List<Widget> _buidChildren() {
    final primaryText = model.prinaryButtonText;
    final subText = model.subText;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buidPasswordTextField(),
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
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buidChildren(),
      ),
    );
  }
}
