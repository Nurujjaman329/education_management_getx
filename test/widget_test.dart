// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';
import 'package:edex_365_getx/main.dart';

void main() {
  testWidgets('App loads and shows a widget', (WidgetTester tester) async {
    // Build your app
    await tester.pumpWidget(const MyApp());

    // Wait for animations and frames to settle
    await tester.pumpAndSettle();

    // Example: check if your app shows some welcome text or app name
    // Replace 'Welcome' below with actual text from your home screen
    expect(find.text('Welcome'), findsOneWidget);

    // If you don't have 'Welcome' text, replace with a widget type you expect
    // e.g. expect(find.byType(SomeWidget), findsOneWidget);
  });
}



// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:edex_365_getx/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
