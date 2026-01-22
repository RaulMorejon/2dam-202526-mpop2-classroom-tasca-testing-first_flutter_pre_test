// lib/presentation/viewmodels/sentence_vm.dart
import 'package:flutter/material.dart';
import '../../data/models/sentence.dart';
import '../../data/repositories/sentence_repository.dart';

class SentenceCreationVM extends ChangeNotifier {
  final ISentenceRepository _sentenceRepository;

  bool isLoading = false;

  Sentence? _createdSentence;

  SentenceCreationVM({
    required ISentenceRepository sentenceRepository,
  }) : _sentenceRepository = sentenceRepository;

  // Getters
  Sentence? get createdSentence => _createdSentence;

  Future<void> createSentence(String text) async {
    isLoading = true;
    _createdSentence = await _sentenceRepository.createSentence(text);
    isLoading = false;

    notifyListeners();
  }

}
