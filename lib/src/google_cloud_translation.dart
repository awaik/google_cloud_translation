import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:html_unescape/html_unescape.dart';

class Translation {
  /// The Google cloud translation token associated with your project.
  /// create it here https://console.cloud.google.com/apis/api/translate.googleapis.com/credentials
  final String _apiKey;

  /// We can inject the client required, useful for testing
  Client http = Client();

  static const String _baseUrl =
      'https://translation.googleapis.com/language/translate/v2';

  /// Returns the value of the token in google.
  String get apiKey => _apiKey;

  /// If this is not null, any error will be sent to this function, otherwise `debugPrint` will be used.
  final void Function(Object error)? _onError;

  /// Provides an instance of this class.
  /// The instance of the class created with this constructor will send the events on the fly.
  /// Also, if a request returns an error, this will be logged but the text will be lost.
  /// [token] is the Mixpanel token associated with your project.
  /// [onError] is a callback function that will be executed in case there is an error, otherwise `debugPrint` will be used.
  /// [prefsKey] key to use in the SharedPreferences. If you leave it empty a default name will be used.
  Translation({
    required String apiKey,
    void Function(Object)? onError,
  })  : _apiKey = apiKey,
        _onError = onError;

  /// Sends a request to translate.
  /// [text] text to translate.
  /// [to] to what language translate.
  Future<String> translate({required String text, required String to}) async {
    return _translateText(text: text, to: to);
  }

  /// Proxies the error to the callback function provided or to standard `debugPrint`.
  void _onErrorHandler(Object? error, String message) {
    final errorCallback = _onError;
    if (errorCallback != null) {
      errorCallback(error ?? message);
    } else {
      debugPrint(message);
    }
  }

  /// Sends the event to the mixpanel API endpoint.
  Future<String> _translateText(
      {required String text, required String to}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl?target=$to&key=$_apiKey&q=$text'),
    );

    if (response.statusCode == 200) {
      try {
        final body = json.decode(response.body);
        final translations = body['data']['translations'] as List;
        final translation = translations.first;
        return HtmlUnescape().convert(translation['translatedText']);
      } on Exception catch (e) {
        _onErrorHandler('error parsing answer', e.toString());
        throw Exception();
      }
    } else {
      _onErrorHandler('${response.statusCode}', response.body);
      throw Exception();
    }
  }
}
