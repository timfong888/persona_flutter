import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../types/configurations.dart';
<<<<<<< HEAD
import '../types/typedefs.dart';
=======
import '../types/enums.dart';
>>>>>>> 9f48fbd924ecdfa76d945677fb1a5f5d359c9b57
import 'persona_method_channel.dart';

abstract class PersonaPlatformInterface extends PlatformInterface {
  /// Contructor
  PersonaPlatformInterface() : super(token: _token);

  /// Token
  static final Object _token = Object();

  /// Singleton instance
  static PersonaPlatformInterface _instance = PersonaMethodChannel();

  /// Default instance to use.
  static PersonaPlatformInterface get instance => _instance;

  static set instance(PersonaPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

<<<<<<< HEAD
  /// Called on a successful inquiry.
  InquirySuccessCallback? onSuccess;
=======
  /// The inquiry completed
  InquiryCompleteCallback? onComplete;
>>>>>>> 9f48fbd924ecdfa76d945677fb1a5f5d359c9b57

  /// The inquiry was cancelled by the user
  InquiryCanceledCallback? onCanceled;

  /// The inquiry errored
  InquiryErrorCallback? onError;

<<<<<<< HEAD
  Future<void> start({required InquiryConfiguration configuration}) async {
=======
  Future<void> init({required InquiryConfiguration configuration}) async {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> start() async {
>>>>>>> 9f48fbd924ecdfa76d945677fb1a5f5d359c9b57
    throw UnimplementedError('start() has not been implemented.');
  }
}
