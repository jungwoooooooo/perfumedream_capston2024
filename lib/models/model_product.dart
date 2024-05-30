class Product {
  int? productNo;
  String? productName;
  String? productDetails;
  String? productImageUrl;
  double? price;
  String? category;
  String? productName_lowercase;
  String? content;

  Product({
    this.productNo,
    this.productName,
    this.productDetails,
    this.productImageUrl,
    this.price,
    this.category,
    this.productName_lowercase,
    this.content
  });

  Product.fromJson(Map<String, Object?> json)
      : this(
    productNo: json['productNo'] as int?,
    productName: json['productName'] as String?,
    productDetails: json['productDetails'] as String?,
    productImageUrl: json['productImageUrl'] as String?,
    price: (json['price'] is int) ? (json['price'] as int).toDouble() : json['price'] as double?,
    category: json['category'] as String?,
    productName_lowercase: json['productName_lowercase'] as String?,
    content: json['content'] as String?
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['productNo'] = productNo;
    data['productName'] = productName;
    data['productDetails'] = productDetails;
    data['productImageUrl'] = productImageUrl;
    data['price'] = price;
    data['category'] = category;
    data['productName_lowercase'] = productName_lowercase;
    data['content'] = content;
    return data;
  }
}
