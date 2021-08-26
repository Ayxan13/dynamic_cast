Translation _translation = new _EngTranslation();

enum Lang {
  Aze,
  Eng,
}

void setLanguage(Lang lang) {
  switch (lang) {
    case Lang.Eng:
      _translation = new _EngTranslation();
      break;

    case Lang.Aze:
      _translation = new _AzeTranslation();
      break;
  }
}

Translation get str => _translation;

// Provides translations to various languages
abstract class Translation {
  // Identifiers that start with `meta` are not actually translations.
  // they are meta-information about the translation
  Lang get metaLanguage;
  String get metaCurrentLanguageName;

  String get appName;
  String get signInOrUp;
  String get signUp;
  String get signIn;
  String get signUpBenefits;
}

class _EngTranslation implements Translation {
  @override
  Lang get metaLanguage => Lang.Eng;

  @override
  String get metaCurrentLanguageName => "English";

  @override
  String get appName => "Dynamic Cast";

  @override
  String get signInOrUp => "Sign in or create an account";

  @override
  String get signUp => "Sign up";

  @override
  String get signIn => "Sign in";

  @override
  String get signUpBenefits => "Save the podcasts you like "
      "and sync across all your devices.";
}

class _AzeTranslation implements Translation {
  @override
  Lang get metaLanguage => Lang.Aze;

  @override
  String get metaCurrentLanguageName => "Azərbaycanca";

  @override
  String get appName => "Dinamik Kast";

  @override
  String get signInOrUp => "Daxil ol və ya hesab yarat";

  @override
  String get signUp => "Hesab yarat";

  @override
  String get signIn => "Daxil ol";

  @override
  String get signUpBenefits => "Bəyəndiyin podkastları topla və "
      "bütün cihazların arasında sinxronizasiya et.";
}
