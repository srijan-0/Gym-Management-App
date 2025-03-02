class Notice {
  final String id;
  final String title;
  final String description;
  final DateTime time; // ✅ Ensure this is always a valid DateTime

  Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
  });

  /// ✅ Convert JSON to Notice object
  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['_id'] ?? '', // Ensure id is always a valid string
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      time: _parseDate(json), // ✅ Ensure DateTime is correctly parsed
    );
  }

  /// ✅ Helper function to parse date safely
  static DateTime _parseDate(Map<String, dynamic> json) {
    try {
      if (json['time'] != null && json['time'].toString().isNotEmpty) {
        return DateTime.parse(json['time']); // ✅ Use `time` if available
      } else if (json['createdAt'] != null &&
          json['createdAt'].toString().isNotEmpty) {
        return DateTime.parse(json['createdAt']); // ✅ Fallback to `createdAt`
      } else {
        return DateTime
            .now(); // ✅ Fallback to current time (to prevent crashes)
      }
    } catch (e) {
      return DateTime.now(); // ✅ In case of errors, use current time
    }
  }
}
