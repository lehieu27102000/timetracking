import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddJobPage(),
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
  void _submit() {
    if (_validateAndSaveForm()) {
      print('form save name: $_name, ratePerHour: $_ratePerHour');
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
        onSaved: (value) => _ratePerHour = int.parse(value!),
        onEditingComplete: _submit,
      )
    ];
  }
}
