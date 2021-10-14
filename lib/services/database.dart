
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackingtime/app/home/models/job.dart';
import 'package:trackingtime/services/api_path.dart';

abstract class Database {
  Future <void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;
  Future <void> createJob(Job job) => _setData(
    path: APIPath.job(uid, 'job_123'),
    data: job.toMap()
  );

  Future<void> _setData({String? path, Map<String, dynamic>? data}) async {
    final reference = FirebaseFirestore.instance.doc(path!);
    await reference.set(data!);
  }
}