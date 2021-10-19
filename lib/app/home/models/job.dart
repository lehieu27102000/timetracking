class Job {
  Job({required this.name, required this.ratePerHour});
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return Job(
          name: '',
          ratePerHour: 0
      );
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(
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