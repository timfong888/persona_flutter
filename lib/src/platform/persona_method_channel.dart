import 'package:flutter/services.dart';

<<<<<<< HEAD
import '../types/attributes.dart';
import '../types/configurations.dart';
import '../types/relationships.dart';
=======
import '../types/configurations.dart';
>>>>>>> 9f48fbd924ecdfa76d945677fb1a5f5d359c9b57
import 'persona_platform_interface.dart';

class PersonaMethodChannel extends PersonaPlatformInterface {
  final MethodChannel _channel = const MethodChannel('persona_flutter');

  MethodChannel get channel => _channel;

  PersonaMethodChannel() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  Future<void> init({required InquiryConfiguration configuration}) async {
    return _channel.invokeMethod('init', configuration.toJson());
  }

<<<<<<< HEAD
  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onSuccess':
        final attributes =
            InquiryAttributes.fromJson(call.arguments['attributes']);
        final relationships =
            InquiryRelationships.fromJson(call.arguments['relationships']);
        onSuccess?.call(
            call.arguments['inquiryId'] as String, attributes, relationships);
        break;

      case 'onFailed':
        final attributes =
            InquiryAttributes.fromJson(call.arguments['attributes']);
        final relationships =
            InquiryRelationships.fromJson(call.arguments['relationships']);
        onFailed?.call(
            call.arguments['inquiryId'] as String, attributes, relationships);
=======
  @override
  Future<void> start() async {
    return _channel.invokeMethod('start');
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onComplete":
        String inquiryId = call.arguments['inquiryId'] as String;
        String status = call.arguments['status'] as String;
        Map<String, dynamic> fields = (call.arguments['fields'] as Map).map(
            (key, value) => MapEntry<String, dynamic>(key.toString(), value));
        onComplete?.call(inquiryId, status, fields);
>>>>>>> 9f48fbd924ecdfa76d945677fb1a5f5d359c9b57
        break;
      case "onCanceled":
        String? inquiryId = call.arguments['inquiryId'] as String?;
        String? sessionToken = call.arguments['sessionToken'] as String?;
        onCanceled?.call(inquiryId, sessionToken);
        break;
      case "onError":
        String? error = call.arguments['error'] as String?;
        onError?.call(error);
        break;
      default:
        throw MissingPluginException(
            '${call.method} was invoked but has no handler');
    }
  }
}
