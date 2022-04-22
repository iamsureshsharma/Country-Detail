import 'package:countrydetail/main.dart' as app;
import 'package:countrydetail/utils/const.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {
    testWidgets('test with no internet connectivity', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      expect(find.text(serverError), findsOneWidget);
    });
    testWidgets('test with internet connectivity', (WidgetTester tester) async {
      app.main();
      await tester.pump(const Duration(milliseconds: 4000));
      await tester.pumpAndSettle();

      expect(find.text('About Canada'), findsOneWidget);
    });
  });
}
