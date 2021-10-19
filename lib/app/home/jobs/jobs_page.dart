
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingtime/app/home/jobs/add_job_page.dart';
import 'package:trackingtime/app/home/models/job.dart';
import 'package:trackingtime/common_widgets/show_alert_dialog.dart';
import 'package:trackingtime/services/auth.dart';
import 'package:trackingtime/services/database.dart';



class JobsPage extends StatelessWidget {
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
    final database = Provider.of<Database>(context, listen: false);
    // database.readJobs();
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        centerTitle: true,
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
              onPressed: () => _confirmSignOut(context),
              child: Text('Logout', style: TextStyle(fontSize: 18.0, color: Colors.white),)
          )
        ],
      ),
      body: _buidContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AddJobPage.show(context),
      ),
    );
  }

  Widget _buidContents(BuildContext context) {
    final database = Provider.of<Database>(context,  listen: false);
    return StreamBuilder<Iterable<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          final jobs = snapshot.data;
          final children  = jobs!.map((job) => Text('${job.name} ${job.ratePerHour}')).toList();
          return ListView(children: children,);
        }
        return Center(child: CircularProgressIndicator(),);
      }
    );
  }

  Future <void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'bloging', ratePerHour: 10));
    } on FirebaseException catch(e) {
      showAlertDialog(context, title:
        'Tạo mới không thành công',
        content: '',
        activeDefaultText: 'ok',
        cancelActiveText: null
      );
    }
  }
}
