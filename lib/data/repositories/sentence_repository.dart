import 'package:first_flutter/data/models/sentence.dart';
import 'package:first_flutter/data/services/sentence_service.dart';

abstract class ISentenceRepository {
  List<Sentence> get history;
  List<Sentence> get favorites;
  Future<Sentence> get current;
  
  Future<Sentence> getNext();
  void toggleFavorite(Sentence sentence);
  bool isFavorite(Sentence pair);

  Future<Sentence> createSentence(String text);
}

class SentenceRepository implements ISentenceRepository {
  SentenceRepository({
    required ISentenceService sentenceService,
  }) : _sentenceService = sentenceService;

  final ISentenceService _sentenceService;

  late var _current = _sentenceService.getNext();

  var _favorites = <Sentence>[];

  var _history = <Sentence>[];

  // Getters
  @override
  List<Sentence> get history => _history;
  @override
  List<Sentence> get favorites => _favorites;
  @override
  Future<Sentence> get current => _current;

  @override
  Future<Sentence> getNext() async {
    var next = await _sentenceService.getNext();
    _history.insert(0, await _current);
    _current = Future.value(next);
    return next;
  }

  @override
  void toggleFavorite(Sentence sentence) {
    if (_favorites.contains(sentence)) {
      _favorites.remove(sentence);
    } else {
      _favorites.add(sentence);
    }
  }

  @override
  bool isFavorite(Sentence pair) {
    return _favorites.contains(pair);
  }
  
  @override
  Future<Sentence> createSentence(String text) async {
    return _sentenceService.createSentence(text);
  }
}