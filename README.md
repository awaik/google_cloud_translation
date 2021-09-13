# google_cloud_translation

A dart wrapper on the Google Could Translation API to be used in Flutter applications. As this is
using the http REST API it works both with Android and iOS.

![](https://github.com/awaik/google_cloud_translation/blob/main/example/assets/translate_screen.gif?raw=true)

## How to use it

There is an [example](./example) app that demonstrates how to use the plugin,

You just need to instantiate the class and you'll be ready to send `translate` texts.

NOTICE: This package uses in production, but only for the simple translation. If you need additional
API please create issue or make PR.

```dart
class _MyHomePageState extends State<MyHomePage> {
  late Translation _translation;
  final String _text =
      'Toda persona tiene derecho a la educación. La educación debe ser gratuita, al menos en lo concerniente a la instrucción elemental y fundamental. La instrucción elemental será obligatoria. La instrucción técnica y profesional habrá de ser generalizada; el acceso a los estudios superiores será igual para todos, en función de los méritos respectivos.';
  TranslationModel _translated = TranslationModel(translatedText: '', detectedSourceLanguage: '');

  @override
  void initState() {
    _translation = Translation(
      apiKey: 'YOUR_API_KEY',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translate demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Initial text',
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(_text),
              SizedBox(height: 30),
              Text('Translated text', style: Theme.of(context).textTheme.headline3),
              Text(_translated.translatedText, style: TextStyle(color: Colors.blueAccent)),
              Text('Detected language - ${_translated.detectedSourceLanguage}',
                  style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _translated = await _translation.translate(text: _text, to: 'en');
          setState(() {});
        },
        tooltip: 'Translate',
        child: Icon(Icons.language),
      ),
    );
  }
}
```

