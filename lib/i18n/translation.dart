import 'package:dynamic_cast/constants.dart';

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
  String get email;
  String get password;
  String get passwordHasMinSize;
  String get next;
  String get enterEmail;
  String get emailFormatWrong;
  String get emailHint => "someone@example.com";
  String get forgotPassword;
}

class _EngTranslation extends Translation {
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

  @override
  String get email => "Email";

  @override
  String get password => "Password";

  @override
  String get passwordHasMinSize =>
      "Must be at least $PASSWORD_MIN_LENGTH characters.";

  @override
  String get next => "Next";

  @override
  String get enterEmail => "Please enter your email.";

  @override
  String get emailFormatWrong => "Email format is wrong.";

  @override
  String get forgotPassword => "I forgot my password";
}

class _AzeTranslation extends Translation {
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

  @override
  String get email => "E-poçt";

  @override
  String get password => "Parol";

  @override
  String get passwordHasMinSize =>
      "Ən azı $PASSWORD_MIN_LENGTH hərf olmalıdır.";

  @override
  String get next => "Növbəti";

  @override
  String get enterEmail => "E-poçtunuzu daxil edin.";

  @override
  String get emailFormatWrong => "E-poçt formatı düzgün deyil.";

  @override
  String get forgotPassword => "Parolumu unutdum.";
}
