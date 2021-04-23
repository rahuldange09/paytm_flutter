import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paytm_flutter/paytm_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('paytm_native');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '{}';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

// No points for test cases as can;t share test account nor we have txnToken
  test('startTransaction', () async {
    expect(
        await Paytm().startTransaction(
            mid: "mid",
            orderId: "orderId",
            amount: "amount",
            txnToken: "txnToken"),
        '{}');
  });
}
