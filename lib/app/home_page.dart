import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingtime/common_widgets/show_alert_dialog.dart';
import 'package:trackingtime/services/auth.dart';



class HomePage extends StatelessWidget {
  // const HomePage({Key? key, required this.auth}) : super(key: key);
  // final AuthBase auth;
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final requestLogOut = await showAlertDialog(context,
        title: 'LogOut',
        content: 'Bạn có chắc chắn muốn logout',
        activeDefaultText: 'Logout',
        cancelActiveText: 'Cancel'
    );
    if (requestLogOut == true) {
      _signOut(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page', textAlign: TextAlign.center,),
        actions: <Widget>[
          FlatButton(
              onPressed: () => _confirmSignOut(context),
              child: Text('Logout', style: TextStyle(fontSize: 18.0, color: Colors.white),)
          )
        ],
      ),
    );
  }
}
