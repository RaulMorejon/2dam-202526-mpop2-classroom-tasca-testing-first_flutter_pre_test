// TEST FOR FLUTTER APPLICATION
import 'package:first_flutter/data/models/sentence.dart';
import 'package:first_flutter/data/repositories/sentence_repository.dart';
import 'package:first_flutter/data/services/sentence_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_flutter/main.dart';
import 'package:provider/provider.dart';

// MOCK del servei
class FakeSentenceService implements ISentenceService {
  @override
  Future<Sentence> getNext() async {
    // Retornem una frase fixa, sense HTTP!
    return Sentence(text: 'Test sentence');
  }

  @override
  Future<Sentence> createSentence(String text) async {
    return Sentence(text: text);
  }
}

// Separem els providers en una funció
Widget createTestApp() {
  return MultiProvider(
    providers: [
      Provider<ISentenceService>(create: (_) => FakeSentenceService()),
      Provider<ISentenceRepository>(
        create: (context) =>
            SentenceRepository(sentenceService: context.read()),
      ),
    ],
    child: const MyApp(),
  );
}

void main() {
  // 1. Mostra una frase a la pantalla

  testWidgets('Test mostra frase inicial', (WidgetTester tester) async {
    // Creem l'aplicació amb els providers
    await tester.pumpWidget(createTestApp());
    //  Espera que es completin animacions i futures
    await tester.pumpAndSettle();

    expect(find.text('Test sentence'), findsOneWidget);
  });

  // 2. Té un botó "Next" per obtenir una nova frase

  testWidgets('Test clicar botó Next', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();
    // Busquem el botó Next i el cliquem
    final nextButton = find.widgetWithText(ElevatedButton, 'Next');
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    //La frase encara hi és (perquè el mock sempre retorna el mateix)
    expect(find.text('Test sentence'), findsNWidgets(2));
  });

  // 3. Té un botó "Like" per marcar frases com a favorites

  // Botó like
  testWidgets('Test marcar frase com a favorita', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    // Primer no és favorita
    expect(find.byIcon(Icons.favorite_border), findsWidgets);
    final likeButton = find.widgetWithText(ElevatedButton, 'Like');
    expect(likeButton, findsOneWidget);

    await tester.tap(likeButton); // Donem al botó
    await tester.pumpAndSettle();

    // Ara ha de ser favorita
    expect(find.byIcon(Icons.favorite), findsWidgets);
  });

  // Favorita en el historial
  testWidgets('Test la favorita apareix al historial amb la icona', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    // Marquem la frase com a favorita amb el botó like
    await tester.tap(find.widgetWithText(ElevatedButton, 'Like'));
    await tester.pumpAndSettle();

    // Afegim la frase al historial quan cliquem el botó next
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();

    // icona del cor ple al historial
    expect(find.byIcon(Icons.favorite), findsWidgets);
  });
}
