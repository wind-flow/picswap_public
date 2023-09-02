import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_generator/easy_localization_generator.dart';

part 'localization_manager.g.dart';

// https://docs.google.com/spreadsheets/d/1RWr8FSf3TYj3S0gTNcvYVE3p4cOO6kF8i5YT1PapPdk/edit?usp=sharing
@SheetLocalization(
  docId: '1RWr8FSf3TYj3S0gTNcvYVE3p4cOO6kF8i5YT1PapPdk',
  injectGenerationDateTime: true,
  immediateTranslationEnabled: false,
  version: 1,
  outDir: 'assets/translations',
  outName: 'langs.csv',
  preservedKeywords: [
    'few',
    'many',
    'one',
    'other',
    'two',
    'zero',
    'male',
    'female',
    // '',
  ],
)
class _LocalizationManager {}
