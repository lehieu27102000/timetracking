
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackingtime/app/home/models/entry.dart';
import 'package:trackingtime/app/home/models/job.dart';
import 'package:trackingtime/services/api_path.dart';
import 'package:trackingtime/services/firestore_service.dart';

abstract class Database {
  Future <void> createJob(Job job);
  Stream <List<Job>> jobsStream();
  Future<void> deleteJob(Job job);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job? job});
  Future <void> createEntry(Entry entry);
}
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;
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
  // Stream <List<Entry>> entriesStream({Job? job}) {
  //   final path = APIPath.jobs(uid);
  //   final reference = FirebaseFirestore.instance.collection(path);
  //   final snapshots = reference.snapshots();
  //   return snapshots.map((snapshot) => snapshot.docs.map((snapshot) => Entry.fromMap(snapshot.data(), snapshot.id),).toList());
  // }
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
  Future<void> deleteEntry(Entry entry) async {
    final path = APIPath.entry(uid, entry.id);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Future<void> deleteJob(Job job) async {
    final path = APIPath.job(uid, job.id);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }


  Future<void> _setData({String? path, Map<String, dynamic>? data}) async {
    final reference = FirebaseFirestore.instance.doc(path!);
    await reference.set(data!);
  }
  Future <void> createEntry(Entry entry) => _setData(
      path: APIPath.entry(uid, entry.id),
      data: entry.toMap()
  );

}