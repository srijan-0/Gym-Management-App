// lib/domain/usecases/get_notices.dart

import 'package:login/features/auth/domain/entity/notice.dart';
import 'package:login/features/auth/domain/repository/notice_repository.dart';

class GetNotices {
  final NoticeRepository repository;

  GetNotices(this.repository);

  Future<List<Notice>> execute() async {
    return await repository.getNotices();
  }
}
