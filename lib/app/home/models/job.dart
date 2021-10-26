class Job {
  Job({required this.id, required this.name, required this.ratePerHour});
  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return Job(
          id: '',
          name: '',
          ratePerHour: 0
      );
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    final String id = documentId;
    return Job(
      id: id,
      name: name,
      ratePerHour: ratePerHour
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour
    };
  }
}