// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:nexxus/main.dart';
import 'package:nexxus/src/services/auth_service.dart';

class FakeAuthService extends AuthService {
  @override
  Future<Map<String, dynamic>?> getSession() async => null;
}

void main() {
  testWidgets('Shows login when there is no saved session',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(authService: FakeAuthService()));
    await tester.pumpAndSettle();

    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('INICIAR SESION'), findsOneWidget);
  });
}
