import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.quantity,
    required super.categoryId,
    required super.categoryName,
    required super.images,
    required super.status,
    required super.ratingsReviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      name: json['pName'],
      description: json['pDescription'],
      price: (json['pPrice'] as num).toDouble(),
      quantity: json['pQuantity'],
      categoryId: json['pCategory']['_id'],
      categoryName: json['pCategory']['cName'],
      images: List<String>.from(json['pImages']),
      status: json['pStatus'],
      ratingsReviews: json['pRatingsReviews'],
    );
  }
}
