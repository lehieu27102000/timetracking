
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackingtime/app/home/models/job.dart';
import 'package:trackingtime/services/api_path.dart';

abstract class Database {
  Future <void> createJob(Job job);
  Stream <List<Job>> jobsStream();
}
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;
  Future <void> createJob(Job job) => _setData(
    path: APIPath.job(uid, job.id),
    data: job.toMap()
  );

  Stream <List<Job>> jobsStream() {
    final path = APIPath.jobs(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map((snapshot) => Job.fromMap(snapshot.data(), snapshot.id),).toList());
  }

  Future<void> _setData({String? path, Map<String, dynamic>? data}) async {
    final reference = FirebaseFirestore.instance.doc(path!);
    await reference.set(data!);
  }
}