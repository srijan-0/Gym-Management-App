// lib/domain/repositories/notice_repository.dart

import 'package:login/features/auth/domain/entity/notice.dart';

abstract class NoticeRepository {
  Future<List<Notice>> getNotices();
}
