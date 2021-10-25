import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingtime/app/home/models/job.dart';
import 'package:trackingtime/common_widgets/show_alert_dialog.dart';
import 'package:trackingtime/services/database.dart';
class AddJobPage extends StatefulWidget {

  final Database database;

  const AddJobPage({Key? key, required this.database}) : super(key: key);
  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddJobPage(database: database,),
        fullscreenDialog: true
      )
    );
  }
  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  Future <void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allName = jobs.map((job) => job.name).toList();
        if (allName.contains(_name)) {
          showAlertDialog(
              context,
              title: 'Create faild',
              content: 'Please choose a different job name',
              activeDefaultText: 'OK',
              cancelActiveText: ''
          );
        }
        final job = Job(
            name: _name!,
            ratePerHour: _ratePerHour!
        );
        await widget.database.createJob(job);
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showAlertDialog(
            context,
            title: 'Create faild',
            content: e.toString(),
            activeDefaultText: 'OK',
            cancelActiveText: ''
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('New Job'),
        actions: <Widget>[
          FlatButton(
            child: Text('Save', style: TextStyle(fontSize: 18, color: Colors.white),),
            onPressed: _submit,
          )
        ],
        centerTitle: true,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }
  Widget _buildContent(BuildContext context) {
   return SingleChildScrollView(
     child: Padding(
       padding: EdgeInsets.all(16),
       child: Card(
         child: Padding(
           padding: EdgeInsets.all(16),
           child: _buildForm(context),
         ),
       ),
     ),
   );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _BuildFormChildren(context),
      ),
    );
  }

  List<Widget > _BuildFormChildren(BuildContext context) {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        validator: (value) => value!.isNotEmpty ? null : 'Bạn chưa nhập giở',
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
        onEditingComplete: _submit,
      )
    ];
  }
}
