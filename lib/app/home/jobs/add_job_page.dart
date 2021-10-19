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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('New Job'),
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
             child: Placeholder(),
           ),
         ),
       ),
     );
  }
}
