class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String categoryId;
  final String categoryName;
  final List<String> images;
  final String status;
  final List<dynamic> ratingsReviews;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.categoryName,
    required this.images,
    required this.status,
    required this.ratingsReviews,
  });
}
