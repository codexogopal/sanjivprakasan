class SliderItem {
  final int sliderId;
  final String sliderName;
  final String sliderImage;
  final int sliderPosition;
  final String? sliderUrl;
  final int sliderStatus;
  final String createdAt;
  final String updatedAt;

  SliderItem({
    required this.sliderId,
    required this.sliderName,
    required this.sliderImage,
    required this.sliderPosition,
    this.sliderUrl,
    required this.sliderStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      sliderId: json["slider_id"] ?? 0,
      sliderName: json["slider_name"] ?? "",
      sliderImage: json["slider_image"] ?? "",
      sliderPosition: json["slider_position"] ?? "",
      sliderUrl: json["slider_url"] ?? "",
      sliderStatus: json["slider_status"] ?? 0,
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "slider_id": sliderId,
      "slider_name": sliderName,
      "slider_image": sliderImage,
      "slider_position": sliderPosition,
      "slider_url": sliderUrl,
      "slider_status": sliderStatus,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  // Convert a list of JSON objects to a List of SliderItem objects
  static List<SliderItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SliderItem.fromJson(json)).toList();
  }

  // Convert a List of SliderItem objects to a List of JSON objects
  static List<Map<String, dynamic>> toJsonList(List<SliderItem> list) {
    return list.map((item) => item.toJson()).toList();
  }
}
