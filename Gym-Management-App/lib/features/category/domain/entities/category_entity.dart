import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String cName;
  final String cDescription;
  final String cImage;
  final String cStatus;

  const CategoryEntity({
    required this.id,
    required this.cName,
    required this.cDescription,
    required this.cImage,
    required this.cStatus,
  });

  @override
  List<Object?> get props => [id, cName, cDescription, cImage, cStatus];
}
