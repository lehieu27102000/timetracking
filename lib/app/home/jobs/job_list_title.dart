import 'package:flutter/material.dart';
import 'package:trackingtime/app/home/models/job.dart';
class JobListTitle extends StatelessWidget {
  const JobListTitle({Key? key, required this.job, required this.onTap}) : super(key: key);
  final Job job;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      subtitle: Text('${job.ratePerHour}' + ' minute'),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
