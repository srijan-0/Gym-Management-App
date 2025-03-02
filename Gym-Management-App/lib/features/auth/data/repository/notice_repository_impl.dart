import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:login/features/auth/domain/entity/notice.dart';
import 'package:login/features/auth/domain/repository/notice_repository.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final http.Client client;

  NoticeRepositoryImpl(this.client);

  @override
  Future<List<Notice>> getNotices() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/notice/all-notices');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      // Parse the response body and access the 'notices' field
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> noticesData = data['notices'];

      return noticesData
          .map((json) => Notice.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load notices');
    }
  }
}
