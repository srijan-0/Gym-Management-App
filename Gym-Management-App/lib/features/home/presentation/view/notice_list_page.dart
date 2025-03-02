import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ Import for date formatting
import 'package:login/features/auth/domain/entity/notice.dart';

class NoticeListPage extends StatefulWidget {
  final Future<List<Notice>> notices;

  const NoticeListPage({super.key, required this.notices});

  @override
  _NoticeListPageState createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  final Map<int, bool> _expandedMap =
      {}; // ✅ Track expanded state for each notice

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Notices"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Notice>>(
          future: widget.notices,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No notices available.'));
            } else {
              final notices = snapshot.data!;
              return ListView.builder(
                itemCount: notices.length,
                itemBuilder: (context, index) {
                  bool isExpanded = _expandedMap[index] ?? false;
                  String noticeText = notices[index].description ??
                      "No description available"; // ✅ Prevent null issues

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ✅ Notice Title
                          Text(
                            notices[index].title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          /// ✅ Notice Description with "Read More"
                          Text(
                            isExpanded
                                ? noticeText // ✅ Show full text
                                : _getTrimmedText(
                                    noticeText), // ✅ Show limited text
                            style: const TextStyle(fontSize: 14),
                          ),

                          /// ✅ "Read More / Read Less" Button
                          if (noticeText.length > 100)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _expandedMap[index] =
                                        !isExpanded; // ✅ Toggle expanded state
                                  });
                                },
                                child: Text(
                                  isExpanded ? "Read Less" : "Read More",
                                  style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                          const SizedBox(height: 5),

                          /// ✅ Notice Date & Time
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                _formatDateTime(notices[index].time),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  /// ✅ Format Date & Time for UI (e.g., "Feb 22, 2024 - 10:30 AM")
  String _formatDateTime(DateTime dateTime) {
    return DateFormat("MMM dd, yyyy - hh:mm a").format(dateTime);
  }

  /// ✅ Get trimmed text safely (first 100 characters)
  String _getTrimmedText(String text) {
    return text.length > 100 ? "${text.substring(0, 100)}..." : text;
  }
}
