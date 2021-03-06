
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingtime/app/home/jobs/add_job_page.dart';
import 'package:trackingtime/app/home/jobs/edit_job_page.dart';
import 'package:trackingtime/app/home/jobs/job_list_title.dart';
import 'package:trackingtime/app/home/jobs/list_item_builder.dart';
import 'package:trackingtime/app/home/models/job.dart';
import 'package:trackingtime/common_widgets/show_alert_dialog.dart';
import 'package:trackingtime/services/auth.dart';
import 'package:trackingtime/services/database.dart';

import 'empty_content.dart';



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
  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirestoreDatabase catch(e) {
      showAlertDialog(context,
        title: 'delete faild',
        content: e.toString(),
        activeDefaultText: 'OK',
        cancelActiveText: ''
      );
    }
  }

  Widget _buidContents(BuildContext context) {
    final database = Provider.of<Database>(context,  listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      // builder: (context, snapshot) {
      //   if (snapshot.data != null) {
      //     final jobs = snapshot.data;
      //     if (jobs!.isNotEmpty) {
      //       final children  = jobs.map((job) => JobListTitle(job: job, onTap: () => EditJobPage.show(context, job: job))).toList();
      //       return ListView(children: children,);
      //     }
      //     return EmptyContent();
      //   }
      //   return Center(child: CircularProgressIndicator(),);
      builder: (context, snapshot) {
        return ListItemBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible (
                key: Key('job-${job.id}'),
                background: Container(color: Colors.red,),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => _delete(context, job),
                child: JobListTitle(
                job: job,
                onTap: () => EditJobPage.show(context, job: job)
            )
          )
        );
      }
    );
  }

}
