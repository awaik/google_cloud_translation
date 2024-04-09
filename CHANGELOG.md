## [0.0.3+1]

- Updated compile and target sdk version to 33 (thanks to https://github.com/devendroid)
- Updated kotlin and gradle version (thanks to https://github.com/devendroid)
- Fix Google api key with restriction issue (thanks to https://github.com/devendroid)
- Upgrade http (thanks to https://github.com/alxkzmn)

## [0.0.3]

- Added detectLang option - detects source language without translation. Look the example for the more info.

## [0.0.2+1]

- Made formatting.

## [0.0.2]

- Breaking changes. Now result of translation returns with TranslationModel with two properties
  - translatedText
  - detectedSourceLanguage
    This is helps to detect cases when language we translate To is same as the source.

## [0.0.1+1]

- Fixed readme & description.

## [0.0.1]

- Added first method 'translate' - translate to selected language, autodetect language from given
  text.
