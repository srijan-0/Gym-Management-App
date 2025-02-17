class Notice {
  final String id; // Added the id field
  final String title;
  final String description;
  final DateTime time;

  Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
  });

  // From JSON to Notice object
  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['_id'], // Added _id field
      title: json['title'],
      description: json['description'],
      time: DateTime.parse(json['time']), // Parsing the time correctly
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Adding _id field to JSON
      'title': title,
      'description': description,
      'time':
          time.toIso8601String(), // Converting time to ISO 8601 string format
    };
  }
}
