class Step {
  final int order;
  final String instruction;

  Step({required this.order, required this.instruction});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      order: json['order'],
      instruction: json['instruction'],
    );
  }
}