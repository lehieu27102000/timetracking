import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingtime/app/sign_in/email_sign_page.dart';
import 'package:trackingtime/app/sign_in/sign_in_bloc.dart';
import 'package:trackingtime/app/sign_in/sign_in_button.dart';
import 'package:trackingtime/app/sign_in/social_sign_button.dart';
import 'package:trackingtime/common_widgets/show_alert_dialog.dart';
import 'package:trackingtime/services/auth.dart';

// ignore: must_be_immutable
class SignInPage extends StatelessWidget {

  SignInPage({Key? key, required this.bloc, required this.isLoading}) : super(key: key);
  final SignInBloc bloc;
  final bool isLoading;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider(
            create: (_) => SignInBloc(auth: auth, isLoading: isLoading),
          child: Consumer<SignInBloc>(
            builder: (_, bloc, __) => SignInPage(bloc: bloc, isLoading: isLoading.value,),
          ),
        ),
      ),
    );
  }
  String errorText = '';

  Future<void> _SignInAnonymously(BuildContext context) async {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    try {
      await bloc.signInAnonymously();
    } on FirebaseAuthException catch(error) {
      if (error.code == 'ERROR_ABORTED_BY_USER') {
        errorText = 'Người dùng hủy đăng nhập';
      }
      showAlertDialog(context,
          title: 'Login thất bại',
          content: errorText,
          activeDefaultText: 'OK',
          cancelActiveText: null
      );
    }
  }
  Future<void> _SignInWithGoogle(BuildContext context) async {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    try {
      await bloc.signInWithGoogle();
    } on FirebaseAuthException catch(error) {
      print(error.toString());
      if (error.code == 'ERROR_ABORTED_BY_USER') {
        errorText = 'Người dùng hủy đăng nhập';
      }
      showAlertDialog(context,
          title: 'Login thất bại',
          content: errorText,
          activeDefaultText: 'OK',
          cancelActiveText: null
      );
    }
  }

  Future<void> _SignInWidthFaceBook(BuildContext context) async {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    try {
      await bloc.signInWithFacebook();
    } catch (error) {
      print(error.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // fullscreenDialog: true,
        builder: (context) => EmailSignPage()
      )
    );
  }
  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        centerTitle: true,
        elevation: 100.0,
      ),
      body: _BuildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  //private content
  Widget _BuildContent(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
           _buildHeader(),
            SizedBox(
              height: 8.0,
            ),
            SocialSignButton(
                text: 'Sign in with google',
                textColor: Colors.black87,
                color: Colors.white,
                onPressed: () => isLoading ? null : _SignInWithGoogle(context),
                pathImage: 'images/google-logo.png'
            ),
            SizedBox(
              height: 8.0,
            ),
            SocialSignButton(
                text: 'Sign in with facebook',
                textColor: Colors.white,
                color: Colors.blueAccent,
                onPressed: () => isLoading ? null : _SignInWidthFaceBook(context),
                pathImage: 'images/facebook-logo.png'
            ),
            SizedBox(
              height: 8.0,
            ),
            SignInButton(
                text: 'Sign in with email',
                color: Colors.teal,
                textColor: Colors.white,
                onPressed: () => isLoading ? null : _signInWithEmail(context)
            ),
            SizedBox(
              height: 8.0,
            ),
            Text('Or',
              style: TextStyle(fontSize: 14.0, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8.0,
            ),
            SignInButton(
                text: 'Go to anonmous',
                color: Colors.lime,
                textColor: Colors.black87,
                onPressed: () => isLoading ? null : _SignInAnonymously(context),
            ),
          ],
        ),
      ),
    );
  }
}