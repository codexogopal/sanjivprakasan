class ProductModel {
  final int productId;
  final String productUniqueId;
  final String productName;
  final String? productContent;
  final String? productDescription;
  final String? productPricingTable;
  final String productCategoryId;
  final String productCategoryName;
  final String productTagId;
  final String productLabelId;
  final String productTagName;
  final String productSku;
  final String? productSacCode;
  final String? productBarcode;
  final int productEbookInventory;
  final int productEbookStock;
  final int productFeatured;
  final int productEbookBackorder;
  final String productEbookPrice;
  final String? productType;
  final String productEbookSellingPrice;
  final int productEbookMoq;
  final String productSlug;
  final String productImage;
  final String productTocImage;
  final String? productSyllabusImage;
  final String? productGallery;
  final String productWeight;
  final String productLength;
  final String productWidth;
  final String productHeight;
  final String productEstimatedDays;
  final String productShipmentDays;
  final String productHighlight;
  final int productStatus;
  final int productPhyInventory;
  final int productPhyStock;
  final int productPhyBackorder;
  final String? productPhyPrice;
  final String? productPhySellingPrice;
  final int productPhyMoq;
  final int productPhyDiscount;
  final int productEbookDiscount;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int productPhyTaxRate;
  final int productEbookTaxRate;
  final int productRating;
  final int productReview;
  final String productPdf;
  final String? purchaseDate;

  ProductModel({
    required this.productId,
    required this.productUniqueId,
    required this.productName,
    this.productContent,
    this.productDescription,
    this.productPricingTable,
    required this.productCategoryId,
    required this.productCategoryName,
    required this.productTagId,
    required this.productLabelId,
    required this.productTagName,
    required this.productSku,
    this.productSacCode,
    this.productBarcode,
    required this.productEbookInventory,
    required this.productEbookStock,
    required this.productFeatured,
    required this.productEbookBackorder,
    required this.productEbookPrice,
    this.productType,
    required this.productEbookSellingPrice,
    required this.productEbookMoq,
    required this.productSlug,
    required this.productImage,
    required this.productTocImage,
    this.productSyllabusImage,
    this.productGallery,
    required this.productWeight,
    required this.productLength,
    required this.productWidth,
    required this.productHeight,
    required this.productEstimatedDays,
    required this.productShipmentDays,
    required this.productHighlight,
    required this.productStatus,
    required this.productPhyInventory,
    required this.productPhyStock,
    required this.productPhyBackorder,
    this.productPhyPrice,
    this.productPhySellingPrice,
    required this.productPhyMoq,
    required this.productPhyDiscount,
    required this.productEbookDiscount,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.productPhyTaxRate,
    required this.productEbookTaxRate,
    required this.productRating,
    required this.productReview,
    required this.productPdf,
    this.purchaseDate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    productId: json["product_id"] ?? 0,
    productUniqueId: json["product_uniqueid"] ?? "",
    productName: json["product_name"] ?? "",
    productContent: json["product_content"] ?? "",
    productDescription: json["product_description"] ?? "",
    productPricingTable: json["product_pricing_table"] ?? "",
    productCategoryId: json["product_category_id"] ?? "",
    productCategoryName: json["product_category_name"] ?? "",
    productTagId: json["product_tag_id"] ?? "",
    productLabelId: json["product_label_id"] ?? "",
    productTagName: json["product_tag_name"] ?? "",
    productSku: json["product_sku"] ?? "",
    productSacCode: json["product_saccode"] ?? "",
    productBarcode: json["product_barcode"] ?? "",
    productEbookInventory: json["product_ebook_inventory"] ?? "",
    productEbookStock: json["product_ebook_stock"] ?? 0,
    productFeatured: json["product_featured"] ?? 0,
    productEbookBackorder: json["product_ebook_backorder"] ?? 0,
    productEbookPrice: json["product_ebook_price"] ?? "",
    productType: json["product_type"] ?? "",
    productEbookSellingPrice: json["product_ebook_selling_price"] ?? "",
    productEbookMoq: json["product_ebook_moq"] ?? 0,
    productSlug: json["product_slug"] ?? "",
    productImage: json["product_image"] ?? "",
    productTocImage: json["product_toc_image"] ?? "",
    productSyllabusImage: json["product_syllabus_image"] ?? "",
    productGallery: json["product_gallery"] ?? "",
    productWeight: json["product_weight"] ?? "",
    productLength: json["product_length"] ?? "",
    productWidth: json["product_width"] ?? "",
    productHeight: json["product_height"] ?? "",
    productEstimatedDays: json["product_estimated_days"] ?? "",
    productShipmentDays: json["product_shipment_days"] ?? "",
    productHighlight: json["product_highlight"] ?? "",
    productStatus: json["product_status"] ?? 0,
    productPhyInventory: json["product_phy_inventory"] ?? 0,
    productPhyStock: json["product_phy_stock"] ?? 0,
    productPhyBackorder: json["product_phy_backorder"] ?? 0,
    productPhyPrice: json["product_phy_price"] ?? "",
    productPhySellingPrice: json["product_phy_selling_price"] ?? "",
    productPhyMoq: json["product_phy_moq"] ?? 0,
    productPhyDiscount: json["product_phy_discount"] ?? 0,
    productEbookDiscount: json["product_ebook_discount"] ?? 0,
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    deletedAt: json["deleted_at"] ?? "",
    productPhyTaxRate: json["product_phy_tax_rate"] ?? 0,
    productEbookTaxRate: json["product_ebook_tax_rate"] ?? 0,
    productRating: json["product_rating"] ?? 0,
    productReview: json["product_review"] ?? 0,
    productPdf: json["product_pdf"] ?? "",
    purchaseDate: json["purchase_date"] ?? "",
  );
}
