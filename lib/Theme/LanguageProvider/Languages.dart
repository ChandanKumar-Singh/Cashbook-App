

import 'dart:ui';

class Languages{

  static const List<Locale> languages =[
    Locale('en'),
    Locale('ar'),
    Locale('es'),
    Locale('de'),
    Locale('fr'),
    Locale('el'),
    Locale('et'),
    Locale('nb'),
    Locale('nn'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('hi'),
    Locale('ne'),
    Locale('uk'),
    Locale('hr'),
    Locale('tr'),
    Locale('lv'),
    Locale('lt'),
    Locale('ku'),
    Locale.fromSubtags(
        languageCode: 'zh',
        scriptCode:
        'Hans'), // Generic Simplified Chinese 'zh_Hans'
    Locale.fromSubtags(
        languageCode: 'zh',
        scriptCode:
        'Hant'),
  ];
}


class LanguageEntity {
  final String code;
  final String value;

  const LanguageEntity({
    required this.code,
    required this.value,
  });
}

class LanguageModel {
  final String caption, name, code;
  LanguageModel(this.caption, this.name, this.code);
}
