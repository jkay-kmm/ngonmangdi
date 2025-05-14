class Step {
  final String instruction;
  final int order;

  Step({required this.instruction, required this.order});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      instruction: json['instruction'] as String,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'instruction': instruction, 'order': order};
  }
}
