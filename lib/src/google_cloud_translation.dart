import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_cloud_translation/src/models/translation_model.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart';

export 'package:google_cloud_translation/src/models/translation_model.dart';

class Translation {
  /// The Google cloud translation token associated with your project.
  /// create it here https://console.cloud.google.com/apis/api/translate.googleapis.com/credentials
  final String _apiKey;

  /// We can inject the client required, useful for testing
  Client http = Client();

  /// Header to add with http request
  Map<String, String>? _headers;

  static const String _baseUrl =
      'https://translation.googleapis.com/language/translate/v2';
  static const String _detectPath = '/detect';

  /// Returns the value of the token in google.
  String get apiKey => _apiKey;

  /// If this is not null, any error will be sent to this function, otherwise `debugPrint` will be used.
  final void Function(Object error)? _onError;

  /// Provides an instance of this class.
  /// The instance of the class created with this constructor will send the events on the fly.
  /// Also, if a request returns an error, this will be logged but the text will be lost.
  /// [token] is the token associated with your project.
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
  Future<TranslationModel> translate(
      {required String text, required String to}) async {
    return _translateText(text: text, to: to);
  }

  /// Detects source lang.
  /// [text] text to detect.
  Future<TranslationModel> detectLang({required String text}) async {
    return _detectLang(text: text);
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

  /// Sends the text to translate to the API endpoint.
  Future<TranslationModel> _translateText(
      {required String text, required String to}) async {
    _headers ??= await GoogleApiHeaders().getHeaders();
    final response = await http.post(
        Uri.parse('$_baseUrl?target=$to&key=$_apiKey&q=$text'),
        headers: _headers);

    if (response.statusCode == 200) {
      try {
        final body = json.decode(response.body);
        final translations = body['data']['translations'] as List;
        final translation = translations.first;
        return TranslationModel(
          translatedText: HtmlUnescape().convert(translation['translatedText']),
          detectedSourceLanguage: translation['detectedSourceLanguage'],
        );
      } on Exception catch (e) {
        _onErrorHandler('error parsing answer', e.toString());
        throw Exception();
      }
    } else {
      _onErrorHandler('${response.statusCode}', response.body);
      throw Exception();
    }
  }

  /// Sends the text to detect language to the API endpoint.
  Future<TranslationModel> _detectLang({required String text}) async {
    _headers ??= await GoogleApiHeaders().getHeaders();
    final response = await http.post(
        Uri.parse('$_baseUrl$_detectPath?&key=$_apiKey&q=$text'),
        headers: _headers);

    if (response.statusCode == 200) {
      try {
        final body = json.decode(response.body);
        final detection = body['data']['detections'] as List;
        return TranslationModel(
          translatedText: '',
          detectedSourceLanguage: detection.first.first['language'],
        );
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
