// This is a basic Flutter widget test for TheTechnoQuiz app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:the_techno_quiz/main.dart';

void main() {
  testWidgets('TheTechnoQuiz app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TheTechnoQuizApp());

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that the app loads without errors
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Verify that we have a Scaffold (main screen structure)
    expect(find.byType(Scaffold), findsOneWidget);
    
    // Verify bottom navigation is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('App has proper navigation structure', (WidgetTester tester) async {
    await tester.pumpWidget(const TheTechnoQuizApp());
    await tester.pumpAndSettle();

    // Check that we have bottom navigation items
    final bottomNavBar = find.byType(BottomNavigationBar);
    expect(bottomNavBar, findsOneWidget);
    
    // Verify the app structure exists
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
