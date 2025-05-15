class Step {
  final String instruction;
  final int order;
  final String? detail;
  final String? image;

  Step({
    required this.instruction,
    required this.order,
    required this.detail,
    required this.image,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      instruction: json['instruction'] as String,
      order: json['order'] as int,
      detail: json['detail'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instruction': instruction,
      'order': order,
      if (detail != null) 'detail': detail,
      if (image != null) 'image': image,
    };
  }
}
