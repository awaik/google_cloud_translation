# google_cloud_translation

A dart wrapper on the Google Could Translation API to be used in Flutter applications. As this is
using the http REST API it works both with Android and iOS.

![](https://raw.githubusercontent.com/awaik/google_cloud_translation/blob/main/example/assets/translate_screen.gif)

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
  String _translated = '';

  @override
  void initState() {
    _translation = Translation(
      apiKey: 'google_cloud_translation_api_key',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'initial',
            ),
            Text(_text),
            SizedBox(height: 30),
            Text('translated', style: TextStyle(color: Colors.blueAccent)),
            Text(_translated, style: TextStyle(color: Colors.blueAccent)),
          ],
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

