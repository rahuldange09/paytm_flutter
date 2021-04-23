import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Paytm {
  static const MethodChannel _channel = const MethodChannel('paytm_flutter');

  Future startTransaction(
      {@required String mid,
      @required String orderId,
      @required String amount,
      @required String txnToken,
      String callbackUrl,
      bool isStaging = false}) async {
    assert(mid != null);
    assert(orderId != null);
    assert(amount != null);
    assert(txnToken != null);
    assert(isStaging != null);

    String finalCallbackUrl;
    if (callbackUrl == null || callbackUrl.isEmpty) {
      finalCallbackUrl = (isStaging
              ? 'https://securegw-stage.paytm.in'
              : 'https://securegw.paytm.in') +
          '/theia/paytmCallback?ORDER_ID=' +
          orderId;
    } else {
      finalCallbackUrl = callbackUrl;
    }

    final arguments = <String, dynamic>{
      "mid": mid,
      "orderId": orderId,
      "amount": amount,
      "txnToken": txnToken,
      "callbackUrl": finalCallbackUrl,
      "isStaging": isStaging
    };

    try {
      final result = await _channel.invokeMethod("startTransaction", arguments);
      return _getStructuredResult(result);
    } catch (err) {
      throw err;
    }
  }

  Map _getStructuredResult(result) {
    Map<String, dynamic> resultInMap = {};
    try {
      if (Platform.isAndroid) {
        if (result is String) {
          if (result.startsWith("{")) {
            resultInMap = json.decode(result);
          } else if (result.startsWith("Bundle")) {
            final List<String> resultData = result
                .replaceAll(" ", "")
                .split("[{")[1]
                .split("}]")
                .first
                .split(",");

            for (final parameter in resultData) {
              final keyValues = parameter.split("=");
              resultInMap[keyValues.first] = keyValues.last;
            }
            // resultInMap = json.decode(result);
          }
        }
      } else if (Platform.isIOS) {
        if (result is Map) {
          result.forEach((key, value) {
            resultInMap[key] = value;
          });
          return resultInMap;
        }
      }
      if (resultInMap.isEmpty) {
        resultInMap.putIfAbsent("response", () => result.toString());
      }
    } catch (e) {}
    return resultInMap;
  }
}
