class Sentence {
  // Constructor
  Sentence({required this.text});

  // Atributs
  String text;

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'title': String title} => Sentence(
        text: title,
      ),
      _ => throw const FormatException('Failed to load Sentence.'),
    };
  }

  // Mètodes
  void myMethod() {
    // Implementació del mètode
  }
}